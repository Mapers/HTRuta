import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:HTRuta/models/minutes_response.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';

class MapCoordenationDrivePage extends StatefulWidget {
  final LocationEntity currentLocation;
  final String passengerDocumentId;
  final AvailableRouteEntity availablesRoutesEntity;
  final double price;
  final String documentId;
  final String passengerPhone;
  MapCoordenationDrivePage(this.documentId, {Key key, @required this.availablesRoutesEntity,@required this.price, this.passengerDocumentId, this.currentLocation, this.passengerPhone}) : super(key: key);

  @override
  _MapCoordenationDrivePageState createState() => _MapCoordenationDrivePageState();
}

class _MapCoordenationDrivePageState extends State<MapCoordenationDrivePage> {
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  LocationEntity currenActual;
  LocationUtil _locationUtil = LocationUtil();
  final pickUpApi = PickupApi();
  AproxElement element;
  BitmapDescriptor currentPinLocationIcon;
  InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
  StreamSubscription subscription;
  @override
  void initState() {
    currenActual = widget.currentLocation;
    element = AproxElement(distance: null, duration: null, status: null);
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      element = await pickUpApi.calculateMinutes( currenActual.latLang.latitude , currenActual.latLang.longitude, widget.availablesRoutesEntity.route.toLocation.latLang.latitude, widget.availablesRoutesEntity.route.toLocation.latLang.longitude);
      dynamic result = await Future.wait([
        LocationUtil.currentLocation(),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_pick_96.png'),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/car_top_96.png'),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_marker_32.png'),
      ]);
      openLoadingDialog(context);
      _mapViewerUtil.changeToDarkMode;
      Polyline polyline = await _mapViewerUtil.generatePolyline('ROUTE_FROM_TO', widget.availablesRoutesEntity.route.fromLocation, widget.availablesRoutesEntity.route.toLocation);
      Navigator.of(context).pop();
      polylines[polyline.polylineId] = polyline;
      currenActual = result[0];
      Marker markerFrom = MapViewerUtil.generateMarker(
        latLng: widget.availablesRoutesEntity.route.fromLocation.latLang ,
        nameMarkerId: 'FROM_POSITION_MARKER',
        icon: result[1]
      );
      _markers[markerFrom.markerId] = markerFrom;
      Marker markerTo = MapViewerUtil.generateMarker(
        latLng: widget.availablesRoutesEntity.route.toLocation.latLang ,
        nameMarkerId: 'TO_POSITION_MARKER',
        icon: result[1]
      );
      _markers[markerTo.markerId] = markerTo;

      _locationUtil.initListener(listen: (_locationPassenger){
        currenActual = _locationPassenger;
        subscription ??= interprovincialClientDataFirebase.streamInterprovincialLocationDriver(documentId: widget.documentId).listen((interprovincialLocationDriver){
          Marker markerDrive = MapViewerUtil.generateMarker(
            latLng: interprovincialLocationDriver.location.latLang,
            nameMarkerId: 'DRIVE_POSITION_MARKER',
            icon: result[2],
            onTap: (){
              //! Ver info del conductor
            }
          );
          _markers[markerDrive.markerId] = markerDrive;
          _updateMarkerCurrentPosition(interprovincialLocationDriver.location);
          setState(() {});
        });
      });
      setState(() {});
    });
    super.initState();
  }
  void _updateMarkerCurrentPosition(LocationEntity _driverLocation) async{
    element = await pickUpApi.calculateMinutes( currenActual.latLang.latitude , currenActual.latLang.longitude, widget.availablesRoutesEntity.route.toLocation.latLang.latitude, widget.availablesRoutesEntity.route.toLocation.latLang.longitude);
    print(element.distance.text);
    Marker markerPassenger = MapViewerUtil.generateMarker(
      latLng: currenActual.latLang,
      nameMarkerId: 'CURRENT_POSITION_MARKER',
      icon: currentPinLocationIcon
    );
    _markers[markerPassenger.markerId] = markerPassenger;
    double distanceInMeters = LocationUtil.calculateDistanceInMeters(currenActual.latLang, _driverLocation.latLang);
    interprovincialClientDataFirebase.updateCurrentPosition(documentId: widget.documentId, passengerPosition: currenActual, passengerDocumentId: widget.passengerDocumentId, distanceInMeters: distanceInMeters, passengerPhone: widget.passengerPhone);
    bool passengerStatus = await interprovincialClientDataFirebase.seePassengerStatus(documentId: widget.documentId, passengerDocumentId: widget.passengerDocumentId);
    if(passengerStatus){
      Navigator.of(context).pushAndRemoveUntil(Routes.toQualificationClientPage(  documentId:widget.documentId ,passengerId:widget.passengerDocumentId ,availablesRoutesEntity: widget.availablesRoutesEntity ) , (_) => false);
    }
  }

  @override
  void dispose() {
    _locationUtil.disposeListener();
    subscription?.cancel();
    super.dispose();
  }
  
  Future<void> makePhoneCall(String url) async {
      await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _mapViewerUtil.build(
            currentLocation: currenActual.latLang,
            markers: _markers,
            polyLines: polylines,
            height: MediaQuery.of(context).size.height,
          )
        ),
        widget.availablesRoutesEntity.route.driverImage == null? Container() : Positioned(
          top: 90,
          right: 15,
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: green1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(150),
            ),
            child: InkWell(
              onTap: ()async{
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      content:Container(
                        width: 150,
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill, image: NetworkImage(widget.availablesRoutesEntity.route.driverImage)
                          ),
                        ),
                      ),
                    )
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(widget.availablesRoutesEntity.route.driverImage)
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            )
          ),
        ),
        Positioned(
          top: 25,
          right: 15,
          left: 15,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Llegarás a tu destino en '+ element.duration.text +' aproximadamente. Recuerda acercarte a tu ruta, tambien puede llamar al conductor.',
                    style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic, ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          )
        ),
        widget.availablesRoutesEntity.route.driverCellphone== null? Container(): Positioned(
          bottom: 200,
          right: 11,
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: green1,
            child: InkWell(
              onTap: ()async{
                await launch('tel:+51'+widget.availablesRoutesEntity.route.driverCellphone );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.call, color: Colors.white,),
                    Text('Llamar al conductor', style: TextStyle( color: Colors.white), ),
                  ],
                ),
              ),
            ),
          )
        ),
        Positioned(
          bottom: 0,
          right: 15,
          left: 15,
          child: CardAvailiblesRoutes(availablesRoutesEntity: widget.availablesRoutesEntity ,price: widget.price,)
        ),
      ],
    );
  }
}

class CardAvailiblesRoutes extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  final double price;
  const CardAvailiblesRoutes({Key key,@required this.availablesRoutesEntity,@required this.price}) : super(key: key);

  @override
  _CardAvailiblesRoutesState createState() => _CardAvailiblesRoutesState();
}

class _CardAvailiblesRoutesState extends State<CardAvailiblesRoutes> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.availablesRoutesEntity.route.name,
                    style: textStyleHeading18Black,
                  )
                ),
                SizedBox(width: 10),
                Text('S/.' + widget.price.toStringAsFixed(2) , style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: 90,
                  decoration: BoxDecoration(
                    color: widget.availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? Colors.green : Colors.amber ,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? 'En paradero':'En ruta',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.face, color: Colors.black87),
                SizedBox(width: 5),
                Expanded(
                  child: Text(widget.availablesRoutesEntity.route.driverName ?? '' , style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),

              ],
            ),
            Row(
              children: [
                Icon(Icons.trip_origin, color: Colors.amber),
                SizedBox(width: 5),
                Expanded(
                  child: Text(widget.availablesRoutesEntity.route.fromLocation.streetName, style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 5),
                Expanded(
                  child: Text(widget.availablesRoutesEntity.route.toLocation.streetName, style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.black87),
                SizedBox(width: 5),
                Text(widget.availablesRoutesEntity.routeStartDateTime.formatOnlyTimeInAmPM, style: TextStyle(color: Colors.black87, fontSize: 14)),
                SizedBox(width: 20),
                Icon(Icons.calendar_today, color: Colors.blueAccent),
                SizedBox(width: 5),
                Text(widget.availablesRoutesEntity.routeStartDateTime.formatOnlyDate, style: TextStyle(color: Colors.black87, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/local/interprovincial_client_data_local.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';

class MapCoordenationDrivePage extends StatefulWidget {
  final String passengerDocumentId;
  final AvailableRouteEntity availablesRoutesEntity;
  final double price;
  final String documentId;
  MapCoordenationDrivePage(this.documentId, {Key key, @required this.availablesRoutesEntity,@required this.price, this.passengerDocumentId}) : super(key: key);

  @override
  _MapCoordenationDrivePageState createState() => _MapCoordenationDrivePageState();
}

class _MapCoordenationDrivePageState extends State<MapCoordenationDrivePage> {
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  LocationEntity currenActual;
  LocationUtil _locationUtil = LocationUtil();
  BitmapDescriptor currentPinLocationIcon;
  InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();


  StreamSubscription subscription;
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      dynamic result = await Future.wait([
        LocationUtil.currentLocation(),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_pick_96.png'),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/car_top_96.png'),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_marker_32.png'),
      ]);
      openLoadingDialog(context);
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

      InterprovincialClientDataLocal interprovincialClientDataLocal = getIt<InterprovincialClientDataLocal>();
      interprovincialClientDataLocal.saveDocumentIdOnServiceInterprovincial(widget.documentId);

      _locationUtil.initListener(listen: (_locationPassenger){
        subscription ??= interprovincialClientDataFirebase.streamInterprovincialLocationDriver(documentId: widget.documentId).listen((interprovincialLocationDriver){
          Marker markerDrive = MapViewerUtil.generateMarker(
            latLng: interprovincialLocationDriver.location.latLang,
            nameMarkerId: 'DRIVE_POSITION_MARKER',
            icon: result[2],
            onTap: (){
              print('Data del conductor');
            }
          );
          _markers[markerDrive.markerId] = markerDrive;
          _updateMarkerCurrentPosition(_locationPassenger, interprovincialLocationDriver.location);
          setState(() {});
        });
      });
      setState(() {});
    });
    super.initState();
  }
  void _updateMarkerCurrentPosition(LocationEntity _passengerLocation, LocationEntity _driverLocation) async{
    Marker markerPassenger = MapViewerUtil.generateMarker(
      latLng: _passengerLocation.latLang,
      nameMarkerId: 'CURRENT_POSITION_MARKER',
      icon: currentPinLocationIcon
    );
    _markers[markerPassenger.markerId] = markerPassenger;
    DataInterprovincialClientState param = BlocProvider.of<InterprovincialClientBloc>(context).state;
    print(param.passengerDocumentId );
    double distanceInMeters = LocationUtil.calculateDistance(_passengerLocation.latLang, _driverLocation.latLang);
    interprovincialClientDataFirebase.updateCurrentPosition(documentId: widget.documentId, passengerPosition: currenActual, passengerDocumentId: param.passengerDocumentId, distanceInMeters: distanceInMeters);
  }

  @override
  void dispose() {
    _locationUtil.disposeListener();
    subscription?.cancel();
    super.dispose();
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
        Positioned(
          top: 400,
          right: 15,
          left: 15,
          child: CardAvailiblesRoutes(availablesRoutesEntity: widget.availablesRoutesEntity ,price: widget.price,)
        ),
      ],
    );
  }
}

class CardAvailiblesRoutes extends StatelessWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  final double price;
  const CardAvailiblesRoutes({Key key,@required this.availablesRoutesEntity,@required this.price}) : super(key: key);
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
                    availablesRoutesEntity.route.name,
                    style: textStyleHeading18Black,
                  )
                ),
                SizedBox(width: 10),
                Text('S/.' + price.toStringAsFixed(2) , style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            // Row(
            //   children: [
            //     Container(
            //       padding: EdgeInsets.all(4),
            //       margin: EdgeInsets.symmetric(vertical: 5),
            //       width: 90,
            //       decoration: BoxDecoration(
            //         color: availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? Colors.green : Colors.amber ,
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //       child: Text(
            //         availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? 'En paradero':'En ruta',
            //         style: TextStyle(color: Colors.white, fontSize: 12),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     SizedBox(width: 10,),
            //   ],
            // ),
            Row(
              children: [
                Icon(Icons.person, color: Colors.black87),
                SizedBox(width: 5),
                Expanded(
                  child: Text(availablesRoutesEntity.route.nameDriver , style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black87),
                SizedBox(width: 5),
                Expanded(
                  child: Text(availablesRoutesEntity.route.fromLocation.streetName, style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.directions_bus_rounded, color: Colors.black87),
                SizedBox(width: 5),
                Expanded(
                  child: Text(availablesRoutesEntity.route.toLocation.streetName, style: TextStyle(color: Colors.black87, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.black87),
                SizedBox(width: 5),
                Text(availablesRoutesEntity.routeStartDateTime.formatOnlyTimeInAmPM, style: TextStyle(color: Colors.black87, fontSize: 14)),
                SizedBox(width: 20),
                Icon(Icons.calendar_today, color: Colors.black87),
                SizedBox(width: 5),
                Text(availablesRoutesEntity.routeStartDateTime.formatOnlyDate, style: TextStyle(color: Colors.black87, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
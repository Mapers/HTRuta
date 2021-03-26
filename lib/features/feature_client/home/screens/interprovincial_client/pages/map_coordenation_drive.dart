import 'dart:async';

import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/coments_widgets.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';


class MapCoordenationDrivePage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  final LocationEntity currenActual;
  final String documentId;
  MapCoordenationDrivePage(this.documentId, {Key key, @required this.currenActual, @required this.availablesRoutesEntity}) : super(key: key);

  @override
  _MapCoordenationDrivePageState createState() => _MapCoordenationDrivePageState();
}

class _MapCoordenationDrivePageState extends State<MapCoordenationDrivePage> {
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  LocationEntity currenActual;

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
      Polyline polyline = await _mapViewerUtil.generatePolylineXd('ROUTE_FROM_TO', widget.availablesRoutesEntity.route.fromLocation.latLang, widget.availablesRoutesEntity.route.toLocation.latLang);
      Navigator.of(context).pop();
      polylines[polyline.polylineId] = polyline;
      setState(() {
      });

      Marker markerFrom = _mapViewerUtil.generateMarker(
        latLng: widget.availablesRoutesEntity.route.fromLocation.latLang ,
        nameMarkerId: 'FROM_POSITION_MARKER',
        icon: result[1]
      );
      _markers[markerFrom.markerId] = markerFrom;
      Marker markerTo = _mapViewerUtil.generateMarker(
        latLng: widget.availablesRoutesEntity.route.toLocation.latLang ,
        nameMarkerId: 'TO_POSITION_MARKER',
        icon: result[1]
      );
      _markers[markerTo.markerId] = markerTo;

      InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
<<<<<<< HEAD
      //! Consultar de base de datos el documentID
      String documentId = 'dQhq0ZEzFRxN8IczLOz8';
      subscription = interprovincialClientDataFirebase.streamInterprovincialLocationDriver(documentId: documentId).listen((interprovincialLocationDriver){
=======
      subscription = interprovincialClientDataFirebase.streamInterprovincialLocationDriver(documentId: widget.documentId).listen((interprovincialLocationDriver){
>>>>>>> 96303e36c805aafdccc69b5a5e281abcfacd896a
        Marker markerDrive = _mapViewerUtil.generateMarker(
          latLng: interprovincialLocationDriver.location.latLang,
          nameMarkerId: 'DRIVE_POSITION_MARKER',
          icon: result[2],
          onTap: (){
            print('Data del conductor');
          }
        );
        _markers[markerDrive.markerId] = markerDrive;
      });
    });
    super.initState();
  }

  @override
  void dispose() { 
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
            currentLocation: widget.currenActual.latLang,
            markers: _markers,
            polyLines: polylines,
            height: MediaQuery.of(context).size.height,
          )
        ),
        Positioned(
          top: 400,
          right: 15,
          left: 15,
          child: CardAvailiblesRoutes(availablesRoutesEntity: widget.availablesRoutesEntity ,)
        ),
        SaveButtonWidget(context),
      ],
    );
  }

  Positioned SaveButtonWidget(BuildContext context) {
    return Positioned(
      top: 30,
      right: 15,
      // left: 15,
      child: PrincipalButton(
        width: 100,
        text: 'Cancelar',
        color: Colors.grey,
        onPressed: ()async{
          showDialog(
            context:context,
            builder: (context) {
              return AlertDialog(
                title: Text('¿Esta seguro que quiere cancelar?'),
                actions: [
                  PrincipalButton(
                    width: 100,
                    color: Colors.grey,
                    text: 'no',
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  PrincipalButton(
                    width: 100,
                    text: 'si',
                    onPressed: (){
                      BlocProvider.of<InterprovincialClientBloc>(context).add(InitialInterprovincialClientEvent());
                      Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeClientScreen, (route) => false);
                    },
                  )
                ],
              );
            },
          );
        },
      )
    );
  }
}

class CardAvailiblesRoutes extends StatelessWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  const CardAvailiblesRoutes({Key key, this.availablesRoutesEntity}) : super(key: key);
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
                Text('S/.' + availablesRoutesEntity.route.cost.toStringAsFixed(2), style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: 90,
                  decoration: BoxDecoration(
                    color: availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? Colors.green : Colors.amber ,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? 'En paradero':'En ruta',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10,),
                RatingBar.builder(
                  initialRating: availablesRoutesEntity.route.starts,
                  allowHalfRating: true,
                  itemSize: 18,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: null,
                ),
                Spacer(),
                InkWell(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ComentsWirdgets();
                      }
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ver comen...'),
                  )
                ),
              ],
            ),
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
                SizedBox(width: 15),
                Icon(Icons.airline_seat_recline_normal_rounded, color: Colors.green),
                SizedBox(width: 8),
                Text(availablesRoutesEntity.availableSeats.toString(), style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold))
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
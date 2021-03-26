import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/location_drove_Entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/map_interprovincial_client_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCoordenationDrivePage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  final LocationEntity currenActual;
  final LocationDriveEntity driveData;
  MapCoordenationDrivePage({Key key, this.currenActual, this.availablesRoutesEntity, this.driveData}) : super(key: key);

  @override
  _MapCoordenationDrivePageState createState() => _MapCoordenationDrivePageState();
}

class _MapCoordenationDrivePageState extends State<MapCoordenationDrivePage> {
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  LocationEntity currenActual;
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

      Marker markerDrive = _mapViewerUtil.generateMarker(
        latLng: widget.driveData.coordenationDrive ,
        nameMarkerId: 'DRIVE_POSITION_MARKER',
        icon: result[2],
        onTap: (){
          print('Data del conductor');
        }
      );
      _markers[markerDrive.markerId] = markerDrive;
    });
    super.initState();
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
        SaveButtonWidget(context),
      ],
    );
  }
  Positioned SaveButtonWidget(BuildContext context) {
    return Positioned(
      top: 500,
      right: 15,
      left: 15,
      child: PrincipalButton(
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
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/map_interprovincial_client_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCoordenationDrivePage extends StatefulWidget {
  final  LocationEntity currenActual;
  MapCoordenationDrivePage({Key key, this.currenActual}) : super(key: key);

  @override
  _MapCoordenationDrivePageState createState() => _MapCoordenationDrivePageState();
}

class _MapCoordenationDrivePageState extends State<MapCoordenationDrivePage> {
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Map<MarkerId, Marker> _markers = {};
  LocationEntity currenActual;
  @override
  void initState() { 
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      currenActual = await LocationUtil.currentLocation();
      setState(() {});
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
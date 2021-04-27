import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PositionedTerminatedRouteWidget extends StatelessWidget {
  final Widget child;
  const PositionedTerminatedRouteWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterprovincialDriverLocationBloc, InterprovincialDriverLocationState>(
      builder: (context, locationState) {
        if(locationState is DataInteprovincialDriverLocationState){
          InterprovincialDriverState serviceState = BlocProvider.of<InterprovincialDriverBloc>(context).state;
          if(serviceState is DataInterprovincialDriverState){
            if(serviceState.status == InterprovincialStatus.inRoute && locationState.location != null){
              int diference = serviceState.routeStartDateTime.calculateDifferenceInDays();
              double distance = LocationUtil.calculateDistance(serviceState.routeService.toLocation.latLang, locationState.location.latLang);
              if(distance <= 3 || diference >= 2){
                return Positioned(
                  bottom: 80,
                  left: 80,
                  right: 80,
                  child: RaisedButton(
                    child: Text('Culminar ruta'),
                    onPressed: () => showQuestionTerminatedService(context)
                  )
                );
              }
            }
          }
        }
        return Container();
      },
    );
  }


  void showQuestionTerminatedService(BuildContext context){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Estas seguro de culminar su servicio?'),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          RaisedButton(
            child: Text('Sí, culminar'),
            onPressed: () async{
              Navigator.of(ctx).pop();
              BlocProvider.of<InterprovincialDriverBloc>(context).add(FinishServiceInterprovincialDriverEvent());
            },
          )
        ],
      )
    );
  }
}
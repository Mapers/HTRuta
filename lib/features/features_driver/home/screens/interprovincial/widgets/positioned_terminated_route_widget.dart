import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';

class PositionedTerminatedRouteWidget extends StatelessWidget {
  final double bottom;
  final Widget child;
  const PositionedTerminatedRouteWidget({Key key, this.child, this.bottom = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterprovincialDriverLocationBloc, InterprovincialDriverLocationState>(
      builder: (context, locationState) {
              
        /* if(locationState is DataInterprovincialDriverLocationState){
          InterprovincialDriverState serviceState = BlocProvider.of<InterprovincialDriverBloc>(context).state;
          if(serviceState is DataInterprovincialDriverState){
            final status = [InterprovincialStatus.onWhereabouts, InterprovincialStatus.inRoute];
            if(status.contains(serviceState.status) && locationState.location != null){
              // int diferenceDays = serviceState.routeStartDateTime.calculateDifferenceInDays();
              // double distance = LocationUtil.calculateDistanceInKilometers(serviceState.routeService.toLocation.latLang, locationState.location.latLang);
              // if(distance <= 3 || diferenceDays >= 2){
              //   return 
              // }
            }
          }
        } */
        if(locationState is DataInterprovincialDriverLocationState){
          InterprovincialDriverState serviceState = BlocProvider.of<InterprovincialDriverBloc>(context).state;
          if(serviceState is DataInterprovincialDriverState){
            final status = [InterprovincialStatus.inRoute];
            if(status.contains(serviceState.status) && locationState.location != null){
              // int diferenceDays = serviceState.routeStartDateTime.calculateDifferenceInDays();
              // double distance = LocationUtil.calculateDistanceInKilometers(serviceState.routeService.toLocation.latLang, locationState.location.latLang);
              // if(distance <= 3 || diferenceDays >= 2){
              //   return 
              // }
              return Positioned(
                bottom: bottom,
                left: 80,
                right: 80,
                child: RaisedButton(
                  child: Text('Culminar ruta'),
                  onPressed: () => showQuestionTerminatedService(context)
                )
              );
            }else{
              return Container();
            }
          }else{
            return Container();
          }
        }else{
          return Container();
        }
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
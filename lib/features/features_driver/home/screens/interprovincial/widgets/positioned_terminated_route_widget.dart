import 'package:HTRuta/core/utils/location_util.dart';
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
      builder: (context, state) {
        if(state is DataInteprovincialDriverLocationState){
          InterprovincialDriverState stateService = BlocProvider.of<InterprovincialDriverBloc>(context).state;
          if(stateService is DataInterprovincialDriverState){
            if(stateService.status == InterprovincialStatus.inRoute && state.location != null){
              //? Considerar días transcurridos :D
              double distance = LocationUtil.calculateDistance(stateService.routeService.toLocation.latLang, state.location.latLang);
              if(distance <= 3){
                return Positioned(
                  bottom: 80,
                  left: 80,
                  right: 80,
                  child: RaisedButton(
                    child: Text('Culminar ruta'),
                    onPressed: (){}
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
}
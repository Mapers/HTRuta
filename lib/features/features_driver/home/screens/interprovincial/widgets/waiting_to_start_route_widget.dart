import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_info_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_seat_manager_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingToStartRouteWidget extends StatelessWidget {
  final InterprovincialRouteEntity route;
  final DateTime routeStartDateTime;
  const WaitingToStartRouteWidget({Key key, @required this.route, @required this.routeStartDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PositionedInfoRouteWidget(route: route, routeStartDateTime: routeStartDateTime,),
        PositionedSeatManagerWidget(
          child: RaisedButton.icon(
            icon: Icon(Icons.directions_bus_outlined, color: Colors.white),
            label: Text('INICIAR RUTA', style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: () => _showModal(context),
          ),
        )
      ],
    );
  }

  void _showModal(BuildContext context){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('¿Ya desea iniciar con la ruta?'),
        actions: [
          OutlineButton(
            child: Text('Aún no'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          RaisedButton(
            child: Text('Sí, iniciar', style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: (){
              Navigator.of(context).pop();
              BlocProvider.of<InterprovincialBloc>(context).add(StartRouteInterprovincialEvent());
            },
          ),
        ],
      )
    );
  }
}
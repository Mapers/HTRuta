import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_actions_side_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_info_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_seat_manager_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_terminated_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnWhereaboutsWidget extends StatelessWidget {
  final InterprovincialRouteInServiceEntity route;
  final DateTime routeStartDateTime;
  final String documentId;
  const OnWhereaboutsWidget({Key key, @required this.route, @required this.routeStartDateTime, @required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PositionedInfoRouteWidget(route: route, routeStartDateTime: routeStartDateTime),
        PositionedActionsSideWidget(documentId: documentId),
        PositionedTerminatedRouteWidget(bottom: 130),
        PositionedSeatManagerWidget(
          child: RaisedButton.icon(
            icon: Icon(Icons.directions_bus_outlined, color: Colors.white),
            label: Text('INICIAR RUTA', style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: () => _showModal(context)
          )
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
              BlocProvider.of<InterprovincialDriverBloc>(context).add(StartRouteInterprovincialDriverEvent());
            },
          ),
        ],
      )
    );
  }
}
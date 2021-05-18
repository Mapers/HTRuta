import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/detail_passenger_in_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_actions_side_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_dark_card_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_info_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_seat_manager_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_terminated_route_widget.dart';
import 'package:flutter/material.dart';

class InRouteWidget extends StatelessWidget {
  final InterprovincialRouteInServiceEntity route;
  final DateTime routeStartDateTime;
  final String documentId;
  const InRouteWidget({Key key, @required this.route, @required this.routeStartDateTime, @required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PositionedInfoRouteWidget(route: route, routeStartDateTime: routeStartDateTime, showDataTime: false),
        PositionedDarkCardWidget(
          top: 180,
          text: 'Se encuentra en ruta. Quede atento para el recojo de pasajeros en las cercanías.'
        ),
        Positioned(
          bottom: 80,
          child: DatailPassengerInRouteWidget(),
        ),
        PositionedActionsSideWidget(documentId: documentId, serviceId: route.id,),
        PositionedSeatManagerWidget(),
        PositionedTerminatedRouteWidget()
      ],
    );
  }
}
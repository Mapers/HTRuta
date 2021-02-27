import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/dark_card_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/detail_passenger_in_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_info_route_widget.dart';
import 'package:flutter/material.dart';

class InRouteWidget extends StatelessWidget {
  final InterprovincialRouteEntity route;
  const InRouteWidget({Key key, @required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PositionedInfoRouteWidget(route: route),
        DarkCardWidget(
          top: 120,
          text: 'Se encuentra en ruta. Quede atento para el recojo de pasajeros en las cercanías.'
        ),
        Positioned(
          bottom: 10,
          child: DatailPassengerInRouteWidget(),
        )
      ],
    );
  }
}
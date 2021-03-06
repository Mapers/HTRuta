import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:flutter/material.dart';

class PositionedChooseRouteWidget extends StatelessWidget {
  const PositionedChooseRouteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: PrincipalButton(
        onPressed: (){
          Navigator.of(context).push(Routes.toChooseRouteClientPage());
        },
        text: 'Elegir ruta y transporte'
      ),
    );
  }
}
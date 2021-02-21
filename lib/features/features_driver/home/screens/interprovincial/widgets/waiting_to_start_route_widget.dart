import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/dark_card_widget.dart';
import 'package:flutter/material.dart';

class WaitingToStartRouteWidget extends StatelessWidget {
  const WaitingToStartRouteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DarkCardWidget(
          text: 'Puede aceptar la solicitud de pasajeros antes de iniciar la ruta. Presione en “Iniciar ruta” para comenzar el desplazamiento.'
        )
      ],
    );
  }
}
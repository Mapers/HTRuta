import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/dark_card_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/positioned_info_route_widget.dart';
import 'package:flutter/material.dart';

class WaitingToStartRouteWidget extends StatelessWidget {
  final InterprovincialRouteEntity route;
  const WaitingToStartRouteWidget({Key key, @required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PositionedInfoRouteWidget(route: route),
        DarkCardWidget(
          text: 'Puede aceptar la solicitud de pasajeros antes de iniciar la ruta. Presione en “Iniciar ruta” para comenzar el desplazamiento.'
        ),
        Positioned(
          bottom: 20,
          child: RaisedButton.icon(
            icon: Icon(Icons.directions_bus_outlined, color: Colors.white),
            label: Text('INICIAR RUTA', style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: () => _showModal(context),
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
            onPressed: () => _showModal(context),
          ),
        ],
      )
    );
  }
}
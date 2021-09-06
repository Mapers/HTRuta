import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:flutter/material.dart';


class DragwerCircleFrom extends StatefulWidget {
  @override
  _DragwerCircleFrom createState() => _DragwerCircleFrom();
}

class _DragwerCircleFrom extends State<DragwerCircleFrom> {
  final Session _session = Session();

  UserSession sessionLoaded;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all()
            ),
          ),
        ),
        Icon(Icons.local_activity)
      ],
    );
  }
}
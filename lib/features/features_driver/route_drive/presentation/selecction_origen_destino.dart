import 'package:HTRuta/google_map_helper.dart';
import 'package:flutter/material.dart';

class SelecctionOriginDestination extends StatefulWidget {
  const SelecctionOriginDestination({Key key}) : super(key: key);

  @override
  _SelecctionOriginDestinationState createState() => _SelecctionOriginDestinationState();
}

class _SelecctionOriginDestinationState extends State<SelecctionOriginDestination> {
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _gMapViewHelper.buildMapView(context: context, markers: null, currentLocation: null)
        ],
      ),
    );
  }
}
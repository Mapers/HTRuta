import 'package:HTRuta/google_map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-11.1072, -77.6103),
              zoom: 12,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          )
        ],
      ),
    );
  }
}
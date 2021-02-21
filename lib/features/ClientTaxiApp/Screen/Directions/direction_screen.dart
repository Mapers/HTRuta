import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'directions_view.dart';

class DirectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var placeBloc = Provider.of<PlaceBloc>(context);

    return Scaffold(
      body: DirectionsView(
        placeBloc: placeBloc,
      ),
    );
  }
}
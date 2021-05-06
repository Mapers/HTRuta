import 'package:HTRuta/features/feature_client/home/screens/taxi/taxi_client_screen.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ClientTaxiPlaceBloc>(context);
    return TaxiClientScreen(
      placeBloc: bloc,
    );
  }
}

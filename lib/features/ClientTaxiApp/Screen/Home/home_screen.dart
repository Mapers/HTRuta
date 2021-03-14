import 'package:HTRuta/features/feature_client/home/screens/taxi/taxi_client_screen.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:provider/provider.dart';

import 'home_view.dart';

class HomeScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PlaceBloc>(context);

    return TaxiClientScreen(
      placeBloc: bloc,
    );
  }
}

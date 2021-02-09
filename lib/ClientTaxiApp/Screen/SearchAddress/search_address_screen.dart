import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Screen/SearchAddress/search_address_view.dart';
import 'package:flutter_map_booking/ClientTaxiApp/theme/style.dart';
import 'package:provider/provider.dart';

class SearchAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PlaceBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        title: Text("Buscar dirección",
          style: TextStyle(color: blackColor),
        ),
        iconTheme: IconThemeData(
            color: blackColor
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SearchAddressView(
          placeBloc: bloc,
        )
      )
    );
  }
}
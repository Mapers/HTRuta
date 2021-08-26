import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SearchAddress/search_address_view.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class SearchAddressScreen extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final Position currentLocation;
  final bool from;
  SearchAddressScreen({this.getTo, this.currentLocation, this.from = false});
  @override
  _SearchAddressScreenState createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ClientTaxiPlaceBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        title: Text('Buscar dirección',
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
          getTo: widget.getTo,
          currentPosition: widget.currentLocation,
          from: widget.from
        )
      )
    );
  }
}
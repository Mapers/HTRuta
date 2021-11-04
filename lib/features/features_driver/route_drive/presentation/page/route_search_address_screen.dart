import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/driver_place_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/route_search_address_view.dart';

class RouteSearchAddressScreen extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final Position currentLocation;
  final bool from;
  RouteSearchAddressScreen({this.getTo, this.currentLocation, this.from = false});
  @override
  _RouteSearchAddressScreenState createState() => _RouteSearchAddressScreenState();
}

class _RouteSearchAddressScreenState extends State<RouteSearchAddressScreen> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<DriverTaxiPlaceBloc>(context);

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
        child: RouteSearchAddressView(
          placeBloc: bloc,
          getTo: widget.getTo,
          currentPosition: widget.currentLocation,
          from: widget.from,
        )
      )
    );
  }
}
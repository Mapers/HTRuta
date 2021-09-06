import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/search_address_view_interprovincial.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class SearchAddressScreenInterprovincial extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final Function(LocationEntity) getfrom;
  final LocationEntity fromSelect;
  final LocationEntity toSelect;
  final Position currentLocation;
  final bool from;
  final bool isSelect;
  SearchAddressScreenInterprovincial({this.getTo, this.currentLocation, this.from = false, this.getfrom, this.fromSelect, this.toSelect, this.isSelect});
  @override
  _SearchAddressScreenState createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreenInterprovincial> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ClientTaxiPlaceBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text('Buscar dirección', style: TextStyle(color: blackColor),),
        iconTheme: IconThemeData( color: blackColor),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SearchAddressViewInterprovincial(
          placeBloc: bloc,
          getFrom: widget.getfrom ,
          getTo: widget.getTo,
          currentPosition: widget.currentLocation,
          from: widget.from,
          fromSelect: widget.fromSelect,
          toSelect: widget.toSelect,
          isSelecte: widget.isSelect,
        )
      )
    );
  }
}
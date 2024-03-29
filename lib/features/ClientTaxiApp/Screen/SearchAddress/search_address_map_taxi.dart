import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';

class SearchAddressMapTaxi extends StatefulWidget {
  final ClientTaxiPlaceBloc placeBloc;
  final bool fromLocation;
  final Place initialPosition;
  final Position myCurrentPosition;
  SearchAddressMapTaxi({this.placeBloc, this.fromLocation = true, this.initialPosition, this.myCurrentPosition});

  @override
  _SearchAddressMapTaxiState createState() => _SearchAddressMapTaxiState();
}

class _SearchAddressMapTaxiState extends State<SearchAddressMapTaxi> {

  LatLng coordinatesSelected;
  bool loading = true;
  bool positionHasChanged = false;
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(null);
    if(widget.initialPosition == null){
      updateOriginPointFromCoordinates(LatLng(widget.myCurrentPosition.latitude, widget.myCurrentPosition.longitude));
    }else{
      updateOriginPointFromCoordinates(LatLng(widget.initialPosition.lat, widget.initialPosition.lng));
    }
  }
  void updateOriginPointFromCoordinates(LatLng coordinates) async {
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
      if (placemarks == null || placemarks.isEmpty) return;
      final Placemark newPosition = placemarks[0];
      if(widget.fromLocation){
        widget?.placeBloc?.selectFromLocation(Place(
          name: newPosition.name + ', ' + newPosition.thoroughfare,
          formattedAddress: '',
          lat: coordinates.latitude,
          lng: coordinates.longitude
        ));
      }else{
        widget?.placeBloc?.selectLocation(Place(
          name: newPosition.name + ', ' + newPosition.thoroughfare,
          formattedAddress: '',
          lat: coordinates.latitude,
          lng: coordinates.longitude
        ));
      }
      loading = false;
      if(!mounted) return;
      setState(() {});
    }catch(_){}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punto de llegada'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition != null ? LatLng(widget.initialPosition.lat, widget.initialPosition.lng) : LatLng(widget.myCurrentPosition.latitude, widget.myCurrentPosition.longitude),
              zoom: 15.0,
            ),
            onCameraMove: ( cameraPosition ) {
              coordinatesSelected = cameraPosition.target;
            },
            onCameraMoveStarted: (){
              setState(() {
                loading = true;
              });
            },
            onCameraIdle: (){
              if(coordinatesSelected == null){
                return;
              }
              updateOriginPointFromCoordinates(coordinatesSelected);
            },
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, -25),
              child: Icon( Icons.location_on, size: 50, color: Theme.of(context).primaryColor)
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 10
                  )
                ]
              ),
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: showAddressName(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget showAddressName(){
    if(loading){
      return Row(
        children: [
          CircularProgressIndicator()
        ],
      );
    }else{
      if(widget.fromLocation){
        if(widget.placeBloc.formLocation != null){
          return Text(widget.placeBloc.formLocation.name);
        }else{
          return Text('Dirección de partida');
        }
      }else{
        if(widget.placeBloc.locationSelect != null){
          return Text(widget.placeBloc.locationSelect.name);
        }else{
          return Text('Dirección de llegada');
        }
      }
    }
  }
}
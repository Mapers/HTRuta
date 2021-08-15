import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';

class SearchAddressMap extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final ClientTaxiPlaceBloc placeBloc;
  final Place initialPlace;
  SearchAddressMap({this.placeBloc, this.initialPlace, this.getTo});

  @override
  _SearchAddressMapState createState() => _SearchAddressMapState();
}

class _SearchAddressMapState extends State<SearchAddressMap> {

  LatLng coordinatesSelected;
  bool loading = true;

  void _onMapCreated(GoogleMapController controller) async {
    if(widget.initialPlace != null){
      coordinatesSelected = LatLng(widget.initialPlace.lat, widget.initialPlace.lng);
      LatLng position = LatLng(widget.initialPlace.lat, widget.initialPlace.lng);
      updateOriginPointFromCoordinates(position);
    }
  }
  void updateOriginPointFromCoordinates(LatLng coordinates) async {
    widget?.placeBloc?.selectLocation(null);
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks == null || placemarks.isEmpty) return;
    final Placemark newPosition = placemarks[0];
    LocationEntity to  = LocationEntity( latLang: coordinates ,districtName: newPosition.locality ,provinceName: newPosition.subAdministrativeArea, regionName: newPosition.administrativeArea,streetName: newPosition.thoroughfare);
    if(widget.getTo != null){
      widget.getTo(to);
    }
    widget?.placeBloc?.selectLocation(Place(
      name: newPosition.name + ', ' + newPosition.thoroughfare,
      formattedAddress: '',
      lat: coordinates.latitude,
      lng: coordinates.longitude
    ));
    loading = false;
    if(!mounted) return;
    setState(() {});
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
              target: LatLng(widget.initialPlace.lat, widget.initialPlace.lng),
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
              updateOriginPointFromCoordinates(coordinatesSelected);
            },
          ),
          Center(
            child: Transform.translate(
              offset: Offset(0, -12),
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
                  loading || widget.placeBloc.locationSelect == null ? 
                  CircularProgressIndicator():
                  Text(widget.placeBloc.locationSelect.name),
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
                        Navigator.pop(context);
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
}
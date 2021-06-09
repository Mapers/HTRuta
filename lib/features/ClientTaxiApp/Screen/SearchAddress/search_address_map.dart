import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';

class SearchAddressMap extends StatefulWidget {
  final ClientTaxiPlaceBloc placeBloc;
  SearchAddressMap({this.placeBloc});

  @override
  _SearchAddressMapState createState() => _SearchAddressMapState();
}

class _SearchAddressMapState extends State<SearchAddressMap> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Position _lastKnownPosition;
  GoogleMapController _mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;

  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
    } catch(e) {
      position = null;
    }
    if (!mounted) return;
    _lastKnownPosition = position;
  }
  
  
  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    Position currentPosition = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
    LatLng position = LatLng(currentPosition.latitude, currentPosition.longitude);
    Future.delayed(Duration(milliseconds: 200), () async {
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
          ),
        ),
      );
    });
  }
  void updateOriginPointFromCoordinates(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks == null || placemarks.isEmpty) return;
    final Placemark newPosition = placemarks[0];
    widget?.placeBloc?.selectLocation(Place(
      name: newPosition.name + ', ' + newPosition.thoroughfare,
      formattedAddress: '',
      lat: coordinates.latitude,
      lng: coordinates.longitude
    ));
    MarkerId markerId = MarkerId('origin');
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(coordinates.latitude, coordinates.longitude),
      draggable: true,
      onDragEnd: (LatLng newPosition){
        print(newPosition);
      },
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_96.png'),
    );
    if(!mounted) return;
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    _initLastKnownLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punto de llegada'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(_lastKnownPosition?.latitude ?? 0.0, _lastKnownPosition?.longitude ?? 0.0),
              zoom: 12.0,
            ),
            onTap: (LatLng newPosition){
              updateOriginPointFromCoordinates(newPosition);
            },
            /* onCameraMove: (CameraPosition position) {
              _position = position;
            },
            onCameraIdle: (){
              updateOriginPoint();
            } */
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.placeBloc.locationSelect != null ? widget.placeBloc.locationSelect.name : 'Dejar'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
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
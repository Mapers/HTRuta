 import 'dart:io' show Platform;
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
    changeMapType(3, 'assets/style/dark_mode.json');
    if(widget.initialPlace == null){
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
      updateOriginPointFromCoordinates(position);
    }else{
      LatLng position = LatLng(widget.initialPlace.lat, widget.initialPlace.lng);
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
      updateOriginPointFromCoordinates(position);
    }
  }
  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      _mapController.setMapStyle(mapStyle);
    });
  }
  void changeMapType(int id, String fileName){
    if (fileName == null) {
      setState(() {
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }
  void updateOriginPointFromCoordinates(LatLng coordinates) async {
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
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Punto de llegada'),
        centerTitle: true,
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
            top: 0,
            child: Container(
              color: Colors.grey.withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              child: Text('Seleccione un punto en el mapa y luego presione en el botón amarillo para confirmar', style: TextStyle(fontSize: responsive.ip(2.6),color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                  Text(widget.placeBloc.locationSelect != null ? widget.placeBloc.locationSelect.name : 'Dejar'),
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
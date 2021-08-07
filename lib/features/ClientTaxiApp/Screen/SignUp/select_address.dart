import 'dart:io' show Platform;
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}
class _SelectAddressState extends State<SelectAddress> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Position _lastKnownPosition;
  GoogleMapController _mapController;
  bool checkPlatform = Platform.isIOS;
  Position myCurrentPosition;
  bool positionHasChanged = false;
  Place placeSelected;
  
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(null);
    myCurrentPosition = await Geolocator.getCurrentPosition();
    Future.delayed(const Duration(milliseconds: 200), () async {
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: LatLng(myCurrentPosition.latitude, myCurrentPosition.longitude),
            zoom: 15.0,
          ),
        ),
      );
    });
    updateOriginPointFromCoordinates(LatLng(myCurrentPosition.latitude, myCurrentPosition.longitude));
  }

  Future<void> updateOriginPointFromCoordinates(LatLng coordinates) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks == null || placemarks.isEmpty) return;
    final Placemark newPosition = placemarks[0];
    placeSelected = Place(
      name: '${newPosition.name}, ${newPosition.thoroughfare}',
      formattedAddress: '',
      lat: coordinates.latitude,
      lng: coordinates.longitude
    );
    final MarkerId markerId = MarkerId('origin');
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(coordinates.latitude, coordinates.longitude),
      draggable: true,
      onDragEnd: (LatLng newPosition){
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(placeSelected != null){
          Dialogs.confirm(
            context,
            title: '¿Desea guardar la dirección seleccionada?',
            message: '',
            onCancel: (){
              Navigator.pop(context);
            },
            onConfirm: (){
              Navigator.pop(context, placeSelected);
            },
          );
          return Future.value(false);
        }else{
          Navigator.pop(context);
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dirección'),
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
            ),
            Positioned(
              top: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.symmetric(
                  vertical: mqHeigth(context, 2),
                  horizontal: mqWidth(context, 5)
                ),
                width: MediaQuery.of(context).size.width,
                child: const Text('Seleccione un punto en el mapa y luego presione en el botón amarrillo para confirmar', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                padding: const EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: mqWidth(context, 65),
                      child: Row(
                        children: [
                          Text('Mi dirección: '),
                          Flexible(child: Text(placeSelected != null ? placeSelected.name : '', overflow: TextOverflow.ellipsis,)), 
                        ],
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: (){
                          if(placeSelected == null) return;
                          Navigator.pop(context, placeSelected);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
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
  Position _lastKnownPosition;
  GoogleMapController _mapController;
  bool checkPlatform = Platform.isIOS;
  Position myCurrentPosition;
  bool positionHasChanged = false;
  Place placeSelected;
  LatLng coordinatesSelected;
  bool loading = true;
  
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
    try{
      final List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
      if (placemarks == null || placemarks.isEmpty) return;
      final Placemark newPosition = placemarks[0];
      placeSelected = Place(
        name: '${newPosition.name}, ${newPosition.thoroughfare.isNotEmpty ? newPosition.thoroughfare : newPosition.street}',
        formattedAddress: '',
        lat: coordinates.latitude,
        lng: coordinates.longitude
      );
      loading = false;
      if(!mounted) return;
      setState(() {});
    }catch(_){}
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
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(_lastKnownPosition?.latitude ?? -12.055716, _lastKnownPosition?.longitude ?? -77.061331),
                zoom: 12.0,
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
                          loading ? Row(
                            children: [
                              CircularProgressIndicator()
                            ],
                          ) : 
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
import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/driver_place_bloc.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/core/utils/dialog.dart';

class RouteSearchAddressMap extends StatefulWidget {
  final DriverTaxiPlaceBloc placeBloc;
  final bool fromLocation;
  final LocationEntity initialPosition;
  final Position myCurrentPosition;
  RouteSearchAddressMap({this.placeBloc, this.fromLocation = true, this.initialPosition, this.myCurrentPosition});

  @override
  _RouteSearchAddressMapState createState() => _RouteSearchAddressMapState();
}

class _RouteSearchAddressMapState extends State<RouteSearchAddressMap> {

  LatLng coordinatesSelected;
  bool loading = true;
  bool positionHasChanged = false;
  GoogleMapController _mapController;
  LocationEntity from;
  LocationEntity to;
  bool messageController = false;
  bool error = false;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(null);
    if(widget.initialPosition == null){
      updateOriginPointFromCoordinates(LatLng(widget.myCurrentPosition.latitude, widget.myCurrentPosition.longitude));
    }else{
      updateOriginPointFromCoordinates(LatLng(widget.initialPosition.latLang.latitude, widget.initialPosition.latLang.longitude));
    }
  }
  void updateOriginPointFromCoordinates(LatLng coordinates) async {
    try{
      // List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
      // if (placemarks == null || placemarks.isEmpty) return;
      // final Placemark newPosition = placemarks[0];
      if(widget.fromLocation){
        from =  LocationEntity( latLang: coordinates)  ;
        openLoadingDialog(context);
        List<Placemark> placemarkFrom = await placemarkFromCoordinates(from.latLang.latitude , from.latLang.longitude);
        Placemark placemark = placemarkFrom.first;
        Navigator.of(context).pop();
        if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
          error = false;
          widget?.placeBloc?.selectFromLocation(LocationEntity(
            latLang: from.latLang,
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea ,
            districtName: placemark.locality,
            streetName: placemark.thoroughfare,
          ));
        }else{
          error = true;
          appearMesage();
        }
      }else{
        to =  LocationEntity( latLang: coordinates)  ;
        openLoadingDialog(context);
        List<Placemark> placemarkFrom = await placemarkFromCoordinates(to.latLang.latitude , to.latLang.longitude);
        Placemark placemark = placemarkFrom.first;
        Navigator.of(context).pop();
        if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
          error = false; 
          widget?.placeBloc?.selectToLocation(LocationEntity(
            latLang: to.latLang,
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea ,
            districtName: placemark.locality,
            streetName: placemark.thoroughfare,
          ));
        }else{
          error = true;
          appearMesage();
        }
      }
      loading = false;
      if(!mounted) return;
      setState(() {});
    }catch(_){}
  }
  void appearMesage()async{
    messageController = true;
    setState(() {});
    await Future.delayed(Duration(seconds: 4));
    messageController = false;
    if(mounted){
      setState(() {});
    }
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
              target: widget.initialPosition != null ? LatLng(widget.initialPosition.latLang.latitude, widget.initialPosition.latLang.longitude) : LatLng(widget.myCurrentPosition.latitude, widget.myCurrentPosition.longitude),
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
                      color: error ? primaryColor.withOpacity(0.6): primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: (){
                        if(!error){
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          messageController? PositionedDarkCardWidget(top: 240,text: 'No se encontrol ninguna calle por favor selecione otro punto'):Container(),
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
        if(widget.placeBloc.fromLocation != null){
          return Text(widget.placeBloc.fromLocation.streetName);
        }else{
          return Text('Dirección de partida');
        }
      }else{
        if(widget.placeBloc.toLocation != null){
          return Text(widget.placeBloc.toLocation.streetName);
        }else{
          return Text('Dirección de llegada');
        }
      }
    }
  }
}
class PositionedDarkCardWidget extends StatelessWidget {
  final double top;
  final double bottom;
  final String text;
  const PositionedDarkCardWidget({Key key, this.top, this.bottom, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      left: 15,
      top: top,
      bottom: bottom,
      child: Card(
        color: Colors.black,
        elevation: 20,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: double.infinity ,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
        )
      )
    );
  }
}
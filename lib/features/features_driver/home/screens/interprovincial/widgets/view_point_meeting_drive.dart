import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:HTRuta/core/utils/helpers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
class ViewPointMeetingDrive extends StatefulWidget {
  final GeoPoint geoPoint;
  ViewPointMeetingDrive({Key key, this.geoPoint,}) : super(key: key);

  @override
  _ViewWhereabouthState createState() => _ViewWhereabouthState();
}

class _ViewWhereabouthState extends State<ViewPointMeetingDrive> {
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> _markers = {};
  LocationEntity location = LocationEntity.initalPeruPosition();
  BitmapDescriptor bitmapDescriptor;
  LatLng coordinatesSelected;
  bool loading = true;
  bool positionHasChanged = false;
  String nameBoxWhaereabouthSelecter;
  GoogleMapController _mapController;
  LocationEntity pointMeeting;


  @override
  void initState() {
    super.initState();
    nameBoxWhaereabouthSelecter= '';
    List<Placemark> placemarks;
    pointMeeting = LocationEntity.initialWithLocation(latitude: widget.geoPoint.latitude, longitude: widget.geoPoint.latitude);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      location  = await LocationUtil.currentLocation();
      do {
          placemarks = await placemarkFromCoordinates(widget.geoPoint.latitude, widget.geoPoint.longitude);
        } while (placemarks == null || placemarks.isEmpty);
        Placemark newPosition = placemarks.first ;
        pointMeeting = LocationEntity.fillIn(placemark: newPosition, latLng: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude));
      bitmapDescriptor = await BitmapDescriptor.fromBytes(await assetToBytes('assets/image/marker/whereabout1.png',width: 100));

        setState(() { });
    });
      Marker markerPointMeeting = MapViewerUtil.generateMarker(
        latLng: LatLng(widget.geoPoint.latitude , widget.geoPoint.latitude),
        nameMarkerId: 'POINT_MEETING_POSITION_MARKER',
        icon: bitmapDescriptor

      );
      _markers[markerPointMeeting.markerId] = markerPointMeeting;
      // nameBoxWhaereabouthSelecter = location.streetName == '' ? location.districtName +', ' + location.provinceName  : location.streetName + ', '+ location.districtName + ', ' + location.provinceName;
  }
  void updateOriginPointFromCoordinates({LatLng coordinates}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks == null || placemarks.isEmpty) return;
    Placemark newPosition = placemarks[0];
    pointMeeting = LocationEntity(
      streetName: newPosition.thoroughfare,
      districtName: newPosition.locality,
      provinceName: newPosition.subAdministrativeArea ,
      regionName: newPosition.administrativeArea,
      latLang: coordinates
    );
    nameBoxWhaereabouthSelecter = pointMeeting.streetName == '' ? pointMeeting.districtName +', ' + pointMeeting.provinceName  :pointMeeting.streetName + ', '+ pointMeeting.districtName + ', ' + pointMeeting.provinceName;
    loading = false;
    if(!mounted) return;
    setState(() {});
  }
  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(null);
    if(location.latLang == null){
      updateOriginPointFromCoordinates( coordinates: location.latLang );
    }else{
      updateOriginPointFromCoordinates( coordinates: location.latLang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar paradero'),
        // centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: Set<Marker>.of(_markers.values),
            compassEnabled: false,
            initialCameraPosition: CameraPosition(
              target: location.latLang ,
              zoom: 12,
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
              updateOriginPointFromCoordinates( coordinates: coordinatesSelected);
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
                  loading ? Text('Cargando...') : Expanded(
                    child: Container(
                      child: Text(nameBoxWhaereabouthSelecter),
                    ),
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
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/core/utils/helpers.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/meetin_drive_and_passenger_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/meeting_drive_and_passenger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ViewWhereabouth extends StatefulWidget {
  final LocationEntity whereAbouthOneLocation;
  final LocationEntity whereAbouthTwoLocation;
  final LocationEntity currentLocation;
  ViewWhereabouth({Key key, this.whereAbouthOneLocation, this.whereAbouthTwoLocation, this.currentLocation}) : super(key: key);

  @override
  _ViewWhereabouthState createState() => _ViewWhereabouthState();
}

class _ViewWhereabouthState extends State<ViewWhereabouth> {
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> _markers = {};
  LocationEntity location = LocationEntity.initalPeruPosition();
  LocationEntity locationWhereAbout = LocationEntity.initalPeruPosition();
  BitmapDescriptor whereabouthOneIcon;
  BitmapDescriptor whereabouthTwoIcon;
  LatLng coordinatesSelected;
  bool loading = true;
  bool positionHasChanged = false;
  String nameBoxWhaereabouthSelecter;
  GoogleMapController _mapController;
  Placemark newPosition;

  @override
  void initState() {
    super.initState();
    nameBoxWhaereabouthSelecter = widget.currentLocation.streetName == '' ? widget.currentLocation.districtName +', ' + widget.currentLocation.provinceName  :widget.currentLocation.streetName + ', '+ widget.currentLocation.districtName + ', ' + widget.currentLocation.provinceName;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      location  = await LocationUtil.currentLocation();
      whereabouthOneIcon = await BitmapDescriptor.fromBytes(await assetToBytes('assets/image/marker/whereabout1.png',width: 70));
      whereabouthTwoIcon = await BitmapDescriptor.fromBytes(await assetToBytes('assets/image/marker/whereabout2.png',width: 70));
      Marker markerWhereabouthOne = MapViewerUtil.generateMarker(
        latLng: widget.whereAbouthOneLocation.latLang ,
        nameMarkerId: 'WHEREABOUTHONE_POSITION_MARKER',
        icon: whereabouthOneIcon
      );

      _markers[markerWhereabouthOne.markerId] = markerWhereabouthOne;


      Marker markerWhereabouthTwo = MapViewerUtil.generateMarker(
        latLng: widget.whereAbouthTwoLocation.latLang ,
        nameMarkerId: 'WHEREABOUTHTWO_POSITION_MARKER',
        icon: whereabouthTwoIcon
      );
      _markers[markerWhereabouthTwo.markerId] = markerWhereabouthTwo;
    });
  }
  void updateOriginPointFromCoordinates({LatLng coordinates}) async {
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
      if (placemarks == null || placemarks.isEmpty) return;
      Placemark newPosition = placemarks[0];
      locationWhereAbout = LocationEntity(
        streetName: newPosition.thoroughfare,
        districtName: newPosition.locality,
        provinceName: newPosition.subAdministrativeArea ,
        regionName: newPosition.administrativeArea,
        latLang: coordinates
      );
      nameBoxWhaereabouthSelecter = locationWhereAbout.streetName == '' ? locationWhereAbout.districtName +', ' + locationWhereAbout.provinceName  :locationWhereAbout.streetName + ', '+ locationWhereAbout.districtName + ', ' + locationWhereAbout.provinceName;
      loading = false;
      if(!mounted) return;
      setState(() {});
    }catch(_){}
  }
  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(null);
    if(widget.currentLocation.latLang == null){
      updateOriginPointFromCoordinates( coordinates: widget.currentLocation.latLang );
    }else{
      updateOriginPointFromCoordinates( coordinates: widget.currentLocation.latLang);
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
              target: widget.currentLocation.latLang ,
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
                        DataMeetingDriveAndPassengerState param = BlocProvider.of<MeetingDriveAndPassengerBloc>(context).state;
                        if(param.meetingPoints.length == 3 ){
                          MeetingDriveAndPassengerEntity  pointMeetingEdit = MeetingDriveAndPassengerEntity(id: 3 , pointMeeting: locationWhereAbout, isSelect: param.meetingPoints[2].isSelect);
                          BlocProvider.of<MeetingDriveAndPassengerBloc>(context).add( EditMeetingDriveAndPassengerEvent(meetingPoint: pointMeetingEdit ));
                        }else{
                        MeetingDriveAndPassengerEntity pointMeeting = MeetingDriveAndPassengerEntity(id: 3, pointMeeting: locationWhereAbout, isSelect: false );
                          BlocProvider.of<MeetingDriveAndPassengerBloc>(context).add( AddMeetingDriveAndPassengerEvent(meetingPoint: pointMeeting ));
                        }
                        Navigator.of(context).pop();
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
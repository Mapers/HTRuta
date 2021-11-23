import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/view_point_meeting_drive.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/poin_meeting_drive.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class PointMeetingDriveNegotation extends StatefulWidget {
  final InterprovincialRequestEntity interprovincialRequest;
  PointMeetingDriveNegotation({Key key, this.interprovincialRequest}) : super(key: key);

  @override
  _PointMeetingDriveState createState() => _PointMeetingDriveState();
}

class _PointMeetingDriveState extends State<PointMeetingDriveNegotation> {

  LocationEntity location, pointMeeting, newPointMeeting;
  bool changePointMeeting = false;
  GeoPoint geoPointMeeting;


  @override
  void initState() {
    GeoPoint geoPoint = widget.interprovincialRequest.pointMeeting;
    LatLng latLng =  LatLng(geoPoint.latitude , geoPoint.longitude);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      try{
        location  = await LocationUtil.currentLocation();
        List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude,latLng.longitude);
        if (placemarks == null || placemarks.isEmpty) return;
        Placemark newPosition = placemarks.first;
        pointMeeting = LocationEntity(
          streetName: newPosition.thoroughfare.isNotEmpty ? newPosition.thoroughfare : newPosition.street,
          districtName: newPosition.locality,
          provinceName: newPosition.subAdministrativeArea ,
          regionName: newPosition.administrativeArea,
          latLang: latLng
        );
      }catch(_){}
    });
    super.initState();
  }

  void getnewPointMeeting(LocationEntity newPointMeeting){
    newPointMeeting = newPointMeeting;
    geoPointMeeting = GeoPoint(newPointMeeting.latLang.latitude, newPointMeeting.latLang.longitude);
    changePointMeeting = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PointMeetingDrive(geoPoint: widget.interprovincialRequest.pointMeeting,icon: Icons.location_on,),
        ElevatedButton(
          child: Text('Cambiar punto de encuentro'),
          onPressed: (){
            Navigator.of(context).push( MaterialPageRoute(builder: (context) => ViewPointMeetingDrive( currentLocation: location,whereAbouthOneLocation: pointMeeting,getnewPointMeeting: getnewPointMeeting ,)));
          },
        ),
      ],
    );
  }
}
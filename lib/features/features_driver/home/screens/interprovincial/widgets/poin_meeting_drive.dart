import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/point_meeting_drive_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointMeetingDrive extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final GeoPoint geoPoint;
  const PointMeetingDrive({Key key, this.geoPoint, this.icon, this.iconColor}) : super(key: key);

  @override
  _PointMeetingDriveState createState() => _PointMeetingDriveState();
}

class _PointMeetingDriveState extends State<PointMeetingDrive> {
  LocationEntity pointMeeting;
  @override
  void initState() {
    pointMeeting = LocationEntity.initialWithLocation(latitude: widget.geoPoint.latitude , longitude: widget.geoPoint.longitude );
    List<Placemark> placemarks;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try{
        do {
          placemarks = await placemarkFromCoordinates(widget.geoPoint.latitude, widget.geoPoint.longitude);
        } while (placemarks == null || placemarks.isEmpty);
        Placemark newPosition = placemarks.first ;
        pointMeeting = LocationEntity.fillIn(placemark: newPosition, latLng: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude));
        BlocProvider.of<PointMeetingDriveBloc>(context).add(AddPointMeetingDriveEvent( pointMeeting: pointMeeting));
      }catch(_){}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointMeetingDriveBloc, PointMeetingDriveState>(
      builder: (context, state) {
        if(state is PointMeetingDriveInitial){
          return Center(child: CircularProgressIndicator());
        }
        DataPointMeetingDriveSatete param = state;
        if(param.pointMeeting == null){
          return Center(child: Text('sin data'),);
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(widget.icon, color: widget.iconColor),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocationComplement(title: 'Región: ',subTitle: param.pointMeeting.regionName,),
                      LocationComplement(title: 'Provincia: ',subTitle: param.pointMeeting.provinceName,),
                      LocationComplement(title: 'Distrito: ',subTitle: param.pointMeeting.districtName,),
                      LocationComplement(title: 'Calle: ',subTitle: param.pointMeeting.streetName,),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
class LocationComplement extends StatelessWidget {
  final String title;
  final String subTitle;
  const LocationComplement({Key key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
        Expanded(
          child: Container(
            child: Text(subTitle, style: TextStyle(color: Colors.black87, fontSize: 14))
          ),
        ),
      ],
    );
  }
}
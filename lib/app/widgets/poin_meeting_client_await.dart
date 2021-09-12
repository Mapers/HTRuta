import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointMeetingClient extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final GeoPoint geoPoint;
  const PointMeetingClient({Key key, this.geoPoint, this.icon, this.iconColor}) : super(key: key);

  @override
  _PointMeetingClientState createState() => _PointMeetingClientState();
}

class _PointMeetingClientState extends State<PointMeetingClient> {
  LocationEntity pointMeeting;
  @override
  void initState() {
    pointMeeting = LocationEntity.initialWithLocation(latitude: widget.geoPoint.latitude , longitude: widget.geoPoint.longitude );
    List<Placemark> placemarks;
    print('###################');
    print('llege perros');
    print(widget.geoPoint.latitude);
    print(widget.geoPoint.longitude);
    print('###################');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        do {
          placemarks = await placemarkFromCoordinates(widget.geoPoint.latitude, widget.geoPoint.longitude);
        } while (placemarks == null || placemarks.isEmpty);
        Placemark newPosition = placemarks.first ;
        pointMeeting = LocationEntity.fillIn(placemark: newPosition, latLng: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude));
        setState(() {
        });
        print('..................');
        print(pointMeeting.toMap);
        print('..................');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  LocationComplement(title: 'Región: ',subTitle: pointMeeting.regionName,),
                  LocationComplement(title: 'Provincia: ',subTitle: pointMeeting.provinceName,),
                  LocationComplement(title: 'Distrito: ',subTitle: pointMeeting.districtName,),
                  LocationComplement(title: 'Calle: ',subTitle: pointMeeting.streetName,),
                ],
              ),
            )
          ],
        ),
      ),
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
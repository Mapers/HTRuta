import 'package:HTRuta/app/widgets/poin_meeting_client_await.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/view_point_meeting_drive.dart';
import 'package:flutter/material.dart';

class PointMeetingDriveNegotation extends StatefulWidget {
  final InterprovincialRequestEntity interprovincialRequest;
  PointMeetingDriveNegotation({Key key, this.interprovincialRequest}) : super(key: key);

  @override
  _PointMeetingDriveState createState() => _PointMeetingDriveState();
}

class _PointMeetingDriveState extends State<PointMeetingDriveNegotation> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PointMeetingClient(geoPoint: widget.interprovincialRequest.pointMeeting,icon: Icons.location_on,),
        ElevatedButton(
          child: Text('Cambiar punto de encuentro'),
          onPressed: (){
            Navigator.of(context).push( MaterialPageRoute(builder: (context) => ViewPointMeetingDrive( geoPoint: widget.interprovincialRequest.pointMeeting,)));
          },
        ),
      ],
    );
  }
}
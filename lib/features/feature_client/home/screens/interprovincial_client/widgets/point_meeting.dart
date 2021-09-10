import 'package:HTRuta/app/widgets/metting_drive_and_passenger.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/meeting_drive_and_passenger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointMeeting extends StatefulWidget {
  PointMeeting({Key key}) : super(key: key);

  @override
  _PointMeetingState createState() => _PointMeetingState();
}

class _PointMeetingState extends State<PointMeeting> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingDriveAndPassengerBloc, MeetingDriveAndPassengerState>(
      builder: (context, state) {
        if(state is LoadingMeetingDriveAndPassenger){
          return Center(child: CircularProgressIndicator());
        }
        DataMeetingDriveAndPassengerState param = state;
        if(param.meetingPoints.isEmpty){
          return Center(child: Text('sin data'),);
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: param.meetingPoints.length ,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text('Punto de encuentro '+ param.meetingPoints[index].id.toString(), style: TextStyle(fontStyle: FontStyle.italic ),),
                ),
                MettingDriveAndPassenger(
                  icon: Icons.push_pin,
                  location: param.meetingPoints[index].pointMeeting,
                  isSelecter: param.meetingPoints[index].isSelect,
                  onTap: () => BlocProvider.of<MeetingDriveAndPassengerBloc>(context).add(ChangleMeetingDriveAndPassengerEvent(meetingPoint: param.meetingPoints[index]))
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:HTRuta/features/feature_client/home/entities/meetin_drive_and_passenger_entity.dart';

class InterprovincialClientLocalDataSoruce {


  Future<List<MeetingDriveAndPassengerEntity>> getPoniterMeeting() async{
  List<MeetingDriveAndPassengerEntity> pointMeetings = [];
    return pointMeetings;
  }
  Future<List<MeetingDriveAndPassengerEntity>> addPoniterMeeting({ MeetingDriveAndPassengerEntity pointMeeting, List<MeetingDriveAndPassengerEntity>  currentsPoinMetting }) async{
    List<MeetingDriveAndPassengerEntity> pointMeetings = [];
    pointMeetings = currentsPoinMetting;
    pointMeetings.add(pointMeeting);
    return pointMeetings;
  }
  Future<List<MeetingDriveAndPassengerEntity>> editPoniterMeeting({ MeetingDriveAndPassengerEntity pointMeeting, List<MeetingDriveAndPassengerEntity>  currentsPoinMetting }) async{
    List<MeetingDriveAndPassengerEntity> pointMeetings = [];
    pointMeetings = currentsPoinMetting;
    pointMeetings[2] = pointMeeting;
    return pointMeetings;
  }
  Future<List<MeetingDriveAndPassengerEntity>> changleSelectPoniterMeeting({ MeetingDriveAndPassengerEntity pointMeeting, List<MeetingDriveAndPassengerEntity>  currentsPoinMetting }) async{
    List<MeetingDriveAndPassengerEntity> pointMeetings = [];
    for (MeetingDriveAndPassengerEntity item in currentsPoinMetting) {
      pointMeetings.add(MeetingDriveAndPassengerEntity(id: item.id,pointMeeting: item.pointMeeting,isSelect: false));
    }
    int index = pointMeetings.indexOf(pointMeeting);
    pointMeetings[index] = MeetingDriveAndPassengerEntity(id: pointMeeting.id ,pointMeeting: pointMeeting.pointMeeting  ,isSelect: true);
    return pointMeetings;
  }
}
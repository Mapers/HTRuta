part of 'meeting_drive_and_passenger_bloc.dart';

abstract class MeetingDriveAndPassengerEvent extends Equatable {
  const MeetingDriveAndPassengerEvent();

  @override
  List<Object> get props => [];
}
class GetMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  GetMeetingDriveAndPassengerEvent();
  @override
  List<Object> get props => [];
}

class AddMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final MeetingDriveAndPassengerEntity meetingPoint;
  AddMeetingDriveAndPassengerEvent({this.meetingPoint});
  @override
  List<Object> get props => [meetingPoint];
}
class ChangleMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final MeetingDriveAndPassengerEntity meetingPoint;
  ChangleMeetingDriveAndPassengerEvent({this.meetingPoint});
  @override
  List<Object> get props => [meetingPoint];
}
class EditMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final MeetingDriveAndPassengerEntity meetingPoint;
  EditMeetingDriveAndPassengerEvent({this.meetingPoint});
  @override
  List<Object> get props => [meetingPoint];
}


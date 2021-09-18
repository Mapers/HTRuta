part of 'meeting_drive_and_passenger_bloc.dart';

abstract class MeetingDriveAndPassengerEvent extends Equatable {
  const MeetingDriveAndPassengerEvent();

  @override
  List<Object> get props => [];
}
class GetMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final double amountTotal;
  GetMeetingDriveAndPassengerEvent({@required this.amountTotal});
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
class AddAmoutTotalMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final double amoutTotal;
  AddAmoutTotalMeetingDriveAndPassengerEvent({this.amoutTotal});
  @override
  List<Object> get props => [amoutTotal];
}
class SubtractAmoutTotalMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final double amoutTotal;
  SubtractAmoutTotalMeetingDriveAndPassengerEvent({this.amoutTotal});
  @override
  List<Object> get props => [amoutTotal];
}
class ChangeForInputAmoutTotalMeetingDriveAndPassengerEvent extends MeetingDriveAndPassengerEvent {
  final double amoutTotal;
  ChangeForInputAmoutTotalMeetingDriveAndPassengerEvent({this.amoutTotal});
  @override
  List<Object> get props => [amoutTotal];
}



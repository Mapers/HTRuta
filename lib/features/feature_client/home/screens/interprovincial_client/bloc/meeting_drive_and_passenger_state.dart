part of 'meeting_drive_and_passenger_bloc.dart';

abstract class MeetingDriveAndPassengerState extends Equatable {
  const MeetingDriveAndPassengerState();
  @override
  List<Object> get props => [];
}

class  LoadingMeetingDriveAndPassenger extends MeetingDriveAndPassengerState {}

class DataMeetingDriveAndPassengerState extends MeetingDriveAndPassengerState {
  final List<MeetingDriveAndPassengerEntity> meetingPoints;
  DataMeetingDriveAndPassengerState({this.meetingPoints});
  @override
  List<Object> get props => [meetingPoints];
}


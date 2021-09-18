part of 'meeting_drive_and_passenger_bloc.dart';

abstract class MeetingDriveAndPassengerState extends Equatable {
  const MeetingDriveAndPassengerState();
  @override
  List<Object> get props => [];
}

class  LoadingMeetingDriveAndPassenger extends MeetingDriveAndPassengerState {}

class DataMeetingDriveAndPassengerState extends MeetingDriveAndPassengerState {
  final double amountTotal;
  final List<MeetingDriveAndPassengerEntity> meetingPoints;
  DataMeetingDriveAndPassengerState({@required this.meetingPoints,@required this.amountTotal});
  @override
  List<Object> get props => [meetingPoints, amountTotal];
}


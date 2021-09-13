part of 'point_meeting_drive_bloc.dart';

abstract class PointMeetingDriveState extends Equatable {
  const PointMeetingDriveState();
  
  @override
  List<Object> get props => [];
}

class PointMeetingDriveInitial extends PointMeetingDriveState {}

class DataPointMeetingDriveSatete extends PointMeetingDriveState {
  final LocationEntity pointMeeting;
  DataPointMeetingDriveSatete({@required this.pointMeeting});
}

part of 'point_meeting_drive_bloc.dart';

abstract class PointMeetingDriveEvent extends Equatable {
  const PointMeetingDriveEvent();

  @override
  List<Object> get props => [];
}

class AddPointMeetingDriveEvent extends PointMeetingDriveEvent{
  final LocationEntity pointMeeting;
  AddPointMeetingDriveEvent({@required this.pointMeeting});
}
class EditPointMeetingDriveEvent extends PointMeetingDriveEvent{
  final LocationEntity pointMeeting;
  EditPointMeetingDriveEvent({@required this.pointMeeting});
}
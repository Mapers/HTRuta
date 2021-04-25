part of 'comments_drive_bloc.dart';

abstract class CommentsDriveEvent extends Equatable {
  const CommentsDriveEvent();

  @override
  List<Object> get props => [];
}

class GetCommentsDriveEvent extends CommentsDriveEvent{
  final AvailableRouteEntity availablesRoutesEntity;
  GetCommentsDriveEvent({@required this.availablesRoutesEntity});
}

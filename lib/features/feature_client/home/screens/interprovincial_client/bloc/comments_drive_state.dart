part of 'comments_drive_bloc.dart';

abstract class CommentsDriveState extends Equatable {
  const CommentsDriveState();

  @override
  List<Object> get props => [];
}

class DataCommentsDriveState extends CommentsDriveState {
  final List<CommentsDriverEntity> commentsDriver;
  DataCommentsDriveState({@required this.commentsDriver});

  factory DataCommentsDriveState.initial(){
    return DataCommentsDriveState(
      commentsDriver: null
    );
  }

  DataCommentsDriveState copyWith({@required  List<CommentsDriverEntity> commentsDriver}){
    return DataCommentsDriveState(
      commentsDriver: commentsDriver ?? this.commentsDriver
    );
  }

  @override
  List<Object> get props => [commentsDriver];
}

import 'dart:async';

import 'package:HTRuta/entities/location_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'point_meeting_drive_event.dart';
part 'point_meeting_drive_state.dart';

class PointMeetingDriveBloc extends Bloc<PointMeetingDriveEvent, PointMeetingDriveState> {
  PointMeetingDriveBloc() : super(PointMeetingDriveInitial());

  @override
  Stream<PointMeetingDriveState> mapEventToState(
    PointMeetingDriveEvent event,
  ) async* {
    if(event is AddPointMeetingDriveEvent){
      yield DataPointMeetingDriveSatete(pointMeeting:event.pointMeeting );
    }else if(event is EditPointMeetingDriveEvent){
      yield PointMeetingDriveInitial();
      yield DataPointMeetingDriveSatete(pointMeeting:event.pointMeeting );
    }
  }
}

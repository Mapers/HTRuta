import 'dart:async';

import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_local.dart';
import 'package:HTRuta/features/feature_client/home/entities/meetin_drive_and_passenger_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'meeting_drive_and_passenger_event.dart';
part 'meeting_drive_and_passenger_state.dart';

class MeetingDriveAndPassengerBloc extends Bloc<MeetingDriveAndPassengerEvent, MeetingDriveAndPassengerState> {
  final InterprovincialClientLocalDataSoruce interprovincialClientLocalDataSoruce;
  MeetingDriveAndPassengerBloc(this.interprovincialClientLocalDataSoruce) : super(LoadingMeetingDriveAndPassenger());

  @override
  Stream<MeetingDriveAndPassengerState> mapEventToState(
    MeetingDriveAndPassengerEvent event,
  ) async* {
    if( event is GetMeetingDriveAndPassengerEvent){
      List<MeetingDriveAndPassengerEntity> meetingPoints = await  interprovincialClientLocalDataSoruce.getPoniterMeeting();
      yield DataMeetingDriveAndPassengerState(meetingPoints: meetingPoints, amountTotal: event.amountTotal );
    }else if( event is  AddMeetingDriveAndPassengerEvent){
      DataMeetingDriveAndPassengerState params = state;
      List<MeetingDriveAndPassengerEntity> meetingPoints = await interprovincialClientLocalDataSoruce.addPoniterMeeting( pointMeeting: event.meetingPoint, currentsPoinMetting: params.meetingPoints );
      yield LoadingMeetingDriveAndPassenger();
      yield DataMeetingDriveAndPassengerState(meetingPoints: meetingPoints,amountTotal: params.amountTotal);
    }else if( event is EditMeetingDriveAndPassengerEvent ){
      DataMeetingDriveAndPassengerState params = state;
      List<MeetingDriveAndPassengerEntity> meetingPoints = await interprovincialClientLocalDataSoruce.editPoniterMeeting( pointMeeting: event.meetingPoint, currentsPoinMetting: params.meetingPoints );
      yield LoadingMeetingDriveAndPassenger();
      yield DataMeetingDriveAndPassengerState(meetingPoints: meetingPoints,amountTotal: params.amountTotal );
    }else if( event is ChangleMeetingDriveAndPassengerEvent ){
      DataMeetingDriveAndPassengerState params = state;
      List<MeetingDriveAndPassengerEntity> meetingPoints = await interprovincialClientLocalDataSoruce.changleSelectPoniterMeeting( pointMeeting: event.meetingPoint, currentsPoinMetting: params.meetingPoints );
      yield LoadingMeetingDriveAndPassenger();
      yield DataMeetingDriveAndPassengerState(meetingPoints: meetingPoints, amountTotal: params.amountTotal);
    }else if( event is AddAmoutTotalMeetingDriveAndPassengerEvent){
      DataMeetingDriveAndPassengerState params = state;
      yield LoadingMeetingDriveAndPassenger();
      yield DataMeetingDriveAndPassengerState(meetingPoints: params.meetingPoints , amountTotal: event.amoutTotal );
    }else if( event is SubtractAmoutTotalMeetingDriveAndPassengerEvent){
      DataMeetingDriveAndPassengerState params = state;
      yield LoadingMeetingDriveAndPassenger();
      yield DataMeetingDriveAndPassengerState(meetingPoints: params.meetingPoints , amountTotal: event.amoutTotal );
    }else if( event is ChangeForInputAmoutTotalMeetingDriveAndPassengerEvent){
      DataMeetingDriveAndPassengerState params = state;
      yield LoadingMeetingDriveAndPassenger();
      yield DataMeetingDriveAndPassengerState(meetingPoints: params.meetingPoints , amountTotal: event.amoutTotal );
    }
    
  }
}

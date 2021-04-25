import 'dart:async';

import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/comnts_driver_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'comments_drive_event.dart';
part 'comments_drive_state.dart';

class CommentsDriveBloc extends Bloc<CommentsDriveEvent, CommentsDriveState> {
  final InterprovincialClientRemoteDataSoruce interprovincialClientRemoteDataSoruce;
  CommentsDriveBloc(this.interprovincialClientRemoteDataSoruce) : super(DataCommentsDriveState.initial());

  @override
  Stream<CommentsDriveState> mapEventToState(
    CommentsDriveEvent event,
  ) async* {
    if(event is GetCommentsDriveEvent){
      print('holis');
      List<CommentsDriverEntity> commentsDriver =  await interprovincialClientRemoteDataSoruce.getCommentsRoutes(availablesRoutesEntity: event.availablesRoutesEntity );
      yield DataCommentsDriveState.initial().copyWith(commentsDriver: commentsDriver);
    }
  }
}

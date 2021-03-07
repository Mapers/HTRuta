import 'dart:async';

import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'whereabouts_event.dart';
part 'whereabouts_state.dart';

class WhereaboutsBloc extends Bloc<WhereaboutsEvent, WhereaboutsState> {
  final RouteDriveRepository routeDriveRepository;
  WhereaboutsBloc(this.routeDriveRepository) : super(LoadingWhereaboutsState());

  @override
  Stream<WhereaboutsState> mapEventToState(
    WhereaboutsEvent event,
  ) async* {
    if(event is GetwhereaboutsWhereaboutsEvent){
      yield LoadingWhereaboutsState();
      List<WhereaboutsEntity> whereaabouts = await routeDriveRepository.getWhereAbouts();
      yield DataWhereaboutsState(whereaabouts: whereaabouts);
    }else if(event is OnReorderwhereaboutsWhereaboutsEvent){
      yield LoadingWhereaboutsState();
      List<WhereaboutsEntity> whereaabouts = await routeDriveRepository.editOnOrderWhereAbouts(oldIndex: event.oldIndex, newIndex: event.newIndex);
      yield DataWhereaboutsState(whereaabouts: whereaabouts);
    }else if(event is AddwhereaboutsWhereaboutsEvent){
      yield LoadingWhereaboutsState();
      WhereaboutsEntity whereabout = WhereaboutsEntity( id:'1' ,cost:event.cost,whereabouts: event.whereabouts);
      List<WhereaboutsEntity> whereaabouts = await routeDriveRepository.addWhereAboutsRepository(whereabouts:whereabout);
      yield DataWhereaboutsState(whereaabouts: whereaabouts);
    }else if(event is EditWhereaboutsEvent){
      yield LoadingWhereaboutsState();
      List<WhereaboutsEntity> whereaabouts = await routeDriveRepository.editWhereAboutsRepository(whereabouts: event.whereabouts ,newWhereabouts: event.newWhereabouts );
      yield DataWhereaboutsState(whereaabouts: whereaabouts);
    }else if(event is DeleteWhereaboutsEvent){
      yield LoadingWhereaboutsState();
      List<WhereaboutsEntity> whereaabouts = await routeDriveRepository.deleteWhereAboutsRepository(whereabouts: event.whereabouts  );
      yield DataWhereaboutsState(whereaabouts: whereaabouts);
    }
    
  }
}

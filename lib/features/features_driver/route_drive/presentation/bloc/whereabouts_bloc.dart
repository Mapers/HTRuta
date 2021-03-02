import 'dart:async';

import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      print('hello world');
      List<WhereaaboutsEntity> whereaabouts = await routeDriveRepository.getWhereAbouts();
      yield DataWhereaboutsState(whereaabouts: whereaabouts);
    }else if(event is OnReorderwhereaboutsWhereaboutsEvent){
      
    }
  }
}

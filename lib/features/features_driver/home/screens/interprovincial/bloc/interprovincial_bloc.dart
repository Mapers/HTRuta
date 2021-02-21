import 'dart:async';

import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'interprovincial_event.dart';
part 'interprovincial_state.dart';

class InterprovincialBloc extends Bloc<InterprovincialEvent, InterprovincialState> {
  final InterprovincialDataRemote interprovincialDataRemote;
  InterprovincialBloc({@required this.interprovincialDataRemote}) : super(DataInterprovincialState.initial());

  @override
  Stream<InterprovincialState> mapEventToState(
    InterprovincialEvent event,
  ) async* {
    if(event is GetDataInterprovincialEvent){
      yield DataInterprovincialState.initial();
      await Future.delayed(Duration(seconds: 1));
      yield DataInterprovincialState(
        route: null,
        status: InterprovincialStatus.notEstablished
      );
    }else if(event is SelectRouteInterprovincialEvent){
      yield DataInterprovincialState.initial(loadingMessage: 'Seleccionando ruta');
      await Future.delayed(Duration(seconds: 1));
      yield DataInterprovincialState(
        route: event.route,
        status: InterprovincialStatus.waiting
      );
    }
  }
}

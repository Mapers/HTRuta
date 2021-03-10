import 'dart:async';

import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'interprovincial_client_event.dart';
part 'interprovincial_client_state.dart';

class InterprovincialClientBloc extends Bloc<InterprovincialClientEvent, InterprovincialClientState> {
  InterprovincialClientBloc() : super(DataInterprovincialClientState.initial());

  @override
  Stream<InterprovincialClientState> mapEventToState(
    InterprovincialClientEvent event,
  ) async* {
    if(event is LoadInterprovincialClientEvent){
      await Future.delayed(Duration(seconds: 2));
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.notEstablished
      );
    }else if(event is SearchcInterprovincialClientEvent){
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.searchInterprovincial
      );
    }
  }
}

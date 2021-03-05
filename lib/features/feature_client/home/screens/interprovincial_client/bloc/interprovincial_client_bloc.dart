import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'interprovincial_client_event.dart';
part 'interprovincial_client_state.dart';

class InterprovincialClientBloc extends Bloc<InterprovincialClientEvent, InterprovincialClientState> {
  InterprovincialClientBloc() : super(InterprovincialClientInitial());

  @override
  Stream<InterprovincialClientState> mapEventToState(
    InterprovincialClientEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

import 'dart:async';
import 'package:HTRuta/features/ClientTaxiApp/data/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'client_service_event.dart';
part 'client_service_state.dart';
class ClientServiceBloc extends Bloc<ClientServiceEvent, ClientServiceState> {
  ClientServiceBloc() : super(ClientServiceInitial());
  @override
  Stream<ClientServiceState> mapEventToState(
    ClientServiceEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

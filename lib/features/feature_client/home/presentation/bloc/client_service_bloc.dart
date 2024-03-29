import 'dart:async';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/equatable_client_taxi_app.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'client_service_event.dart';
part 'client_service_state.dart';

class ClientServiceBloc extends Bloc<ClientServiceEvent, ClientServiceState> {
  ClientServiceBloc() : super(DataClientServiceState.initial());
  @override
  Stream<ClientServiceState> mapEventToState(
    ClientServiceEvent event,
  ) async* {
    if(event is ChangeClientServiceEvent){
      DataClientServiceState current = state;
      yield current.copyWith(typeService: event.type);
    }
  }
}

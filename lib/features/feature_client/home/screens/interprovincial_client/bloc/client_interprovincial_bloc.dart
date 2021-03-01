import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'client_interprovincial_event.dart';
part 'client_interprovincial_state.dart';
class ClientInterprovincialBloc extends Bloc<ClientInterprovincialEvent, ClientInterprovincialState> {
  ClientInterprovincialBloc() : super(ClientInterprovincialInitial());
  @override
  Stream<ClientInterprovincialState> mapEventToState(
    ClientInterprovincialEvent event,
  ) async* {
  }
}

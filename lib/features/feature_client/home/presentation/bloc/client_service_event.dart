part of 'client_service_bloc.dart';

abstract class ClientServiceEvent extends EquatableClientTaxiApp{
  ClientServiceEvent();
  @override
  List<Object> get props => [];
}

class ChangeClientServiceEvent extends ClientServiceEvent {
  final TypeServiceEnum type;
  ChangeClientServiceEvent({@required this.type});

  @override
  List<Object> get props => [type];
}
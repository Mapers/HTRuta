part of 'client_service_bloc.dart';
abstract class ClientServiceEvent extends Equatable{
  ClientServiceEvent();
  @override
  List<Object> get props => [];
}

class ChangeDriverServiceEvent extends ClientServiceEvent {
  final TypeServiceEnum type;
  ChangeDriverServiceEvent({@required this.type});

  @override
  List<Object> get props => [type];
}
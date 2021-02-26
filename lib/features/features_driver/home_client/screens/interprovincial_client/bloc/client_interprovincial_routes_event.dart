part of 'client_interprovincial_routes_bloc.dart';

abstract class ClientInterprovincialRoutesEvent extends Equatable {
  const ClientInterprovincialRoutesEvent();

  @override
  List<Object> get props => [];
}
class GetRoutesFoundClientInterprovincialRoutesEvent extends ClientInterprovincialRoutesEvent{
}

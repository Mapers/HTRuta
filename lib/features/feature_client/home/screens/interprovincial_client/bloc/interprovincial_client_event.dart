part of 'interprovincial_client_bloc.dart';

abstract class InterprovincialClientEvent extends Equatable {
  const InterprovincialClientEvent();

  @override
  List<Object> get props => [];
}

class LoadInterprovincialClientEvent extends InterprovincialClientEvent {}
class SearchcInterprovincialClientEvent extends InterprovincialClientEvent {}
class DestinationInterprovincialClientEvent extends InterprovincialClientEvent {
  final LatLng to;
  const DestinationInterprovincialClientEvent({this.to});
  @override
  List<Object> get props => [to];
}

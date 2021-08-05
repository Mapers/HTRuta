part of 'interprovincial_client_bloc.dart';

abstract class InterprovincialClientEvent extends Equatable {
  const InterprovincialClientEvent();

  @override
  List<Object> get props => [];
}

class LoadInterprovincialClientEvent extends InterprovincialClientEvent {}
class SearchcInterprovincialClientEvent extends InterprovincialClientEvent {}
class AvailablesInterprovincialClientEvent extends InterprovincialClientEvent {}
class InitialInterprovincialClientEvent extends InterprovincialClientEvent {}
class DestinationInterprovincialClientEvent extends InterprovincialClientEvent {
  final LatLng to;
  const DestinationInterprovincialClientEvent({this.to});
  @override
  List<Object> get props => [to];
}

class SendDataSolicitudInterprovincialClientEvent extends InterprovincialClientEvent {
  final NegotiationEntity negotiationEntity;
  SendDataSolicitudInterprovincialClientEvent({@required this.negotiationEntity});
}

class AcceptDataSolicitudInterprovincialClientEvent extends InterprovincialClientEvent {
  final String serviceDocumentId;
  final NegotiationEntity negotiationEntity;
  final InterprovincialRequestEntity interprovincialRequest;
  AcceptDataSolicitudInterprovincialClientEvent({@required this.serviceDocumentId, @required this.negotiationEntity, @required this.interprovincialRequest});
}
class RejecDataSolicitudInterprovincialClientEvent extends InterprovincialClientEvent {
  final NegotiationEntity negotiationEntity;
  RejecDataSolicitudInterprovincialClientEvent({@required this.negotiationEntity});
}
class SendQualificationInterprovincialClientEvent extends InterprovincialClientEvent {
  final QualificationEntity qualificationEntity;
  SendQualificationInterprovincialClientEvent({@required this.qualificationEntity});
}


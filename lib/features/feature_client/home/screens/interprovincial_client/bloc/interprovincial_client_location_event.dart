part of 'interprovincial_client_location_bloc.dart';

abstract class InterprovincialClientLocationEvent extends Equatable {
  const InterprovincialClientLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateInterprovincialClientLocationEvent extends InterprovincialClientLocationEvent {
  final LocationEntity driverLocation;
  UpdateInterprovincialClientLocationEvent({@required this.driverLocation});

  @override
  List<Object> get props => [driverLocation];
}

class SetDriverSelectedInterprovincialClientLocationEvent extends InterprovincialClientLocationEvent {
  final bool driver;
  SetDriverSelectedInterprovincialClientLocationEvent({@required this.driver});

  @override
  List<Object> get props => [driver];
}

class SetDocumentIdInterprovincialClientLocationEvent extends InterprovincialClientLocationEvent {
  final String documentId;
  SetDocumentIdInterprovincialClientLocationEvent({@required this.documentId});

  @override
  List<Object> get props => [documentId];
}
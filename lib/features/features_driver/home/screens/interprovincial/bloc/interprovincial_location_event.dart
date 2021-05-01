part of 'interprovincial_location_bloc.dart';

abstract class InterprovincialDriverLocationEvent extends Equatable {
  const InterprovincialDriverLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateDriverLocationInterprovincialDriverLocationEvent extends InterprovincialDriverLocationEvent {
  final LocationEntity driverLocation;
  final InterprovincialStatus status;
  UpdateDriverLocationInterprovincialDriverLocationEvent({@required this.driverLocation, @required this.status});

  @override
  List<Object> get props => [driverLocation, status];
}

class SetPassengerSelectedInterprovincialDriverLocationEvent extends InterprovincialDriverLocationEvent {
  final PassengerEntity passenger;
  SetPassengerSelectedInterprovincialDriverLocationEvent({@required this.passenger});

  @override
  List<Object> get props => [passenger];
}

class RemovePassengerSelectedInterprovincialDriverLocationEvent extends InterprovincialDriverLocationEvent {}
class SetDocumentIdInterprovincialDriverLocationEvent extends InterprovincialDriverLocationEvent {
  final String documentId;
  SetDocumentIdInterprovincialDriverLocationEvent({@required this.documentId});

  @override
  List<Object> get props => [documentId];
}
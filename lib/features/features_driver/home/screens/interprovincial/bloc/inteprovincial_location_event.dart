part of 'inteprovincial_location_bloc.dart';

abstract class InterprovincialDriverLocationEvent extends Equatable {
  const InterprovincialDriverLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateDriverLocationInterprovincialLocationEvent extends InterprovincialDriverLocationEvent {
  final LocationEntity driverLocation;
  final InterprovincialStatus status;
  UpdateDriverLocationInterprovincialLocationEvent({@required this.driverLocation, @required this.status});

  @override
  List<Object> get props => [driverLocation, status];
}

class SetPassengerSelectedInterprovincialLocationEvent extends InterprovincialDriverLocationEvent {
  final PassengerEntity passenger;
  SetPassengerSelectedInterprovincialLocationEvent({@required this.passenger});

  @override
  List<Object> get props => [passenger];
}

class RemovePassengerSelectedInterprovincialLocationEvent extends InterprovincialDriverLocationEvent {}
class SetDocumentIdInterprovincialLocationEvent extends InterprovincialDriverLocationEvent {
  final String documentId;
  SetDocumentIdInterprovincialLocationEvent({@required this.documentId});

  @override
  List<Object> get props => [documentId];
}
part of 'inteprovincial_location_bloc.dart';

abstract class InterprovincialLocationEvent extends Equatable {
  const InterprovincialLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateDriverLocationInterprovincialLocationEvent extends InterprovincialLocationEvent {
  final LocationEntity driverLocation;
  final InterprovincialStatus status;
  UpdateDriverLocationInterprovincialLocationEvent({@required this.driverLocation, @required this.status});

  @override
  List<Object> get props => [driverLocation, status];
}

class SetPassengerSelectedInterprovincialLocationEvent extends InterprovincialLocationEvent {
  final PassengerEntity passenger;
  SetPassengerSelectedInterprovincialLocationEvent({@required this.passenger});

  @override
  List<Object> get props => [passenger];
}

class RemovePassengerSelectedInterprovincialLocationEvent extends InterprovincialLocationEvent {}
class SetDocumentIdInterprovincialLocationEvent extends InterprovincialLocationEvent {
  final String documentId;
  SetDocumentIdInterprovincialLocationEvent({@required this.documentId});

  @override
  List<Object> get props => [documentId];
}
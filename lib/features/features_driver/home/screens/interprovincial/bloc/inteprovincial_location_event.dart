part of 'inteprovincial_location_bloc.dart';

abstract class InterprovincialLocationEvent extends Equatable {
  const InterprovincialLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateDriverLocationInterprovincialLocationEvent extends InterprovincialLocationEvent {
  final LocationEntity driverLocation;
  UpdateDriverLocationInterprovincialLocationEvent({@required this.driverLocation});

  @override
  List<Object> get props => [driverLocation];
}

class SetPassengerSelectedInterprovincialLocationEvent extends InterprovincialLocationEvent {
  final PassengerEntity passenger;
  SetPassengerSelectedInterprovincialLocationEvent({@required this.passenger});

  @override
  List<Object> get props => [passenger];
}

class RemovePassengerSelectedInterprovincialLocationEvent extends InterprovincialLocationEvent {}
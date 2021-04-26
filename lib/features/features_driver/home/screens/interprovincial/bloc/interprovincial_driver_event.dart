part of 'interprovincial_driver_bloc.dart';

abstract class InterprovincialDriverEvent extends Equatable {
  const InterprovincialDriverEvent();

  @override
  List<Object> get props => [];
}

class GetDataInterprovincialDriverEvent extends InterprovincialDriverEvent {
  final String documentId;
  GetDataInterprovincialDriverEvent(this.documentId);
  @override
  List<Object> get props => [documentId];
}

class SelectRouteInterprovincialDriverEvent extends InterprovincialDriverEvent {
  final DateTime dateTime;
  final InterprovincialRouteEntity interprovincialRoute;
  final int availableSeats;
  SelectRouteInterprovincialDriverEvent({@required this.interprovincialRoute, @required this.dateTime, @required this.availableSeats});

  @override
  List<Object> get props => [interprovincialRoute, dateTime, availableSeats];
}

class StartRouteInterprovincialDriverEvent extends InterprovincialDriverEvent {}

class PlusOneAvailableSeatInterprovincialDriverEvent extends InterprovincialDriverEvent {
  final int maxSeats;
  PlusOneAvailableSeatInterprovincialDriverEvent({@required this.maxSeats});

  @override
  List<Object> get props => [maxSeats];
}

class SetLocalAvailabelSeatInterprovincialDriverEvent extends InterprovincialDriverEvent {
  final int newSeats;
  SetLocalAvailabelSeatInterprovincialDriverEvent({@required this.newSeats});

  @override
  List<Object> get props => [newSeats];
}

class MinusOneAvailableSeatInterprovincialDriverEvent extends InterprovincialDriverEvent {}

class FinishServiceInterprovincialDriverEvent extends InterprovincialDriverEvent {}
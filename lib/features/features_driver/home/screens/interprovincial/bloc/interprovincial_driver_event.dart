part of 'interprovincial_driver_bloc.dart';

abstract class InterprovincialDriverEvent extends Equatable {
  const InterprovincialDriverEvent();

  @override
  List<Object> get props => [];
}

class GetDataInterprovincialDriverEvent extends InterprovincialDriverEvent {}

class SelectRouteInterprovincialDriverEvent extends InterprovincialDriverEvent {
  final DateTime dateTime;
  final InterprovincialRouteEntity route;
  final int availableSeats;
  SelectRouteInterprovincialDriverEvent({@required this.route, @required this.dateTime, @required this.availableSeats});

  @override
  List<Object> get props => [route, dateTime, availableSeats];
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
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

class PlusOneAvailabelSeatInterprovincialDriverEvent extends InterprovincialDriverEvent {
  final int maxSeats;
  PlusOneAvailabelSeatInterprovincialDriverEvent({@required this.maxSeats});

  @override
  List<Object> get props => [maxSeats];
}

class MinusOneAvailabelSeatInterprovincialDriverEvent extends InterprovincialDriverEvent {}
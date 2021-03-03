part of 'interprovincial_bloc.dart';

abstract class InterprovincialEvent extends Equatable {
  const InterprovincialEvent();

  @override
  List<Object> get props => [];
}

class GetDataInterprovincialEvent extends InterprovincialEvent {}

class SelectRouteInterprovincialEvent extends InterprovincialEvent {
  final DateTime dateTime;
  final InterprovincialRouteEntity route;
  final int availableSeats;
  SelectRouteInterprovincialEvent({@required this.route, @required this.dateTime, @required this.availableSeats});

  @override
  List<Object> get props => [route, dateTime, availableSeats];
}

class StartRouteInterprovincialEvent extends InterprovincialEvent {}

class UpdateLocationInterprovincialEvent extends InterprovincialEvent {
  final LocationEntity location;
  UpdateLocationInterprovincialEvent(this.location);

  @override
  List<Object> get props => [location];
}

class PlusOneAvailabelSeatInterprovincialEvent extends InterprovincialEvent {
  final int maxSeats;
  PlusOneAvailabelSeatInterprovincialEvent({@required this.maxSeats});

  @override
  List<Object> get props => [maxSeats];
}

class MinusOneAvailabelSeatInterprovincialEvent extends InterprovincialEvent {}
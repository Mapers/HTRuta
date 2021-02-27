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
  SelectRouteInterprovincialEvent({@required this.route, @required this.dateTime});

  @override
  List<Object> get props => [route, dateTime];
}

class StartRouteInterprovincialEvent extends InterprovincialEvent {}
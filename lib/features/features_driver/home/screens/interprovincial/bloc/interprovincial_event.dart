part of 'interprovincial_bloc.dart';

abstract class InterprovincialEvent extends Equatable {
  const InterprovincialEvent();

  @override
  List<Object> get props => [];
}

class GetDataInterprovincialEvent extends InterprovincialEvent {}

class SelectRouteInterprovincialEvent extends InterprovincialEvent {
  final InterprovincialRouteEntity route;
  SelectRouteInterprovincialEvent({@required this.route});

  @override
  List<Object> get props => [route];
}

class StartRouteInterprovincialEvent extends InterprovincialEvent {}
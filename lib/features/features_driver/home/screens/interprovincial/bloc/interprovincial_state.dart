part of 'interprovincial_bloc.dart';

abstract class InterprovincialState extends Equatable {
  const InterprovincialState();
  
  @override
  List<Object> get props => [];
}

enum InterprovincialStatus {
  loading, notEstablished, onWhereabouts, inRoute, 
}

class DataInterprovincialState extends InterprovincialState {
  final String loadingMessage;
  final InterprovincialStatus status;
  final InterprovincialRouteEntity route;
  final DateTime routeStartDateTime;
  DataInterprovincialState({@required this.route, @required this.status, this.loadingMessage, @required this.routeStartDateTime});

  factory DataInterprovincialState.initial({String loadingMessage}){
    return DataInterprovincialState(
      status: InterprovincialStatus.loading,
      route: null,
      routeStartDateTime: null,
      loadingMessage: loadingMessage ?? 'Cargando'
    );
  }

  DataInterprovincialState copyWith({String loadingMessage, InterprovincialStatus status, InterprovincialRouteEntity route, DateTime routeStartDateTime}){
    return DataInterprovincialState(
      loadingMessage: loadingMessage ?? this.loadingMessage,
      status: status ?? this.status,
      route: route ?? this.route,
      routeStartDateTime: routeStartDateTime ?? this.routeStartDateTime,
    );
  }

  @override
  List<Object> get props => [route, status, loadingMessage, routeStartDateTime];
}

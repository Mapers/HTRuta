part of 'interprovincial_driver_bloc.dart';

abstract class InterprovincialState extends Equatable {
  const InterprovincialState();
  
  @override
  List<Object> get props => [];
}

enum InterprovincialStatus {
  loading, notEstablished, onWhereabouts, inRoute, 
}

String toStringFirebaseInterprovincialStatus(InterprovincialStatus status){
  switch (status) {
    case InterprovincialStatus.onWhereabouts:
      return 'ON_WHEREABOUTS';
    case InterprovincialStatus.inRoute:
      return 'IN_ROUTE';
    default:
  }
  return null;
}

class DataInterprovincialState extends InterprovincialState {
  final String loadingMessage;
  final int availableSeats;
  final String documentId;
  final InterprovincialStatus status;
  final InterprovincialRouteEntity route;
  final DateTime routeStartDateTime;
  DataInterprovincialState({@required this.route, @required this.documentId, @required this.status, this.loadingMessage, @required this.routeStartDateTime, @required this.availableSeats});

  factory DataInterprovincialState.initial({String loadingMessage}){
    return DataInterprovincialState(
      status: InterprovincialStatus.loading,
      documentId: null,
      route: null,
      routeStartDateTime: null,
      availableSeats: null,
      loadingMessage: loadingMessage ?? 'Cargando'
    );
  }

  DataInterprovincialState copyWith({String loadingMessage, String documentId, InterprovincialStatus status, InterprovincialRouteEntity route, DateTime routeStartDateTime, int availableSeats}){
    return DataInterprovincialState(
      loadingMessage: loadingMessage ?? this.loadingMessage,
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      route: route ?? this.route,
      routeStartDateTime: routeStartDateTime ?? this.routeStartDateTime,
      availableSeats: availableSeats ?? this.availableSeats,
    );
  }

  @override
  List<Object> get props => [route, status, documentId, loadingMessage, routeStartDateTime, availableSeats];
}

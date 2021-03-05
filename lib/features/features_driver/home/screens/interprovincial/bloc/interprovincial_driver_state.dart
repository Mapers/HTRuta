part of 'interprovincial_driver_bloc.dart';

abstract class InterprovincialDriverState extends Equatable {
  const InterprovincialDriverState();
  
  @override
  List<Object> get props => [];
}

class DataInterprovincialDriverState extends InterprovincialDriverState {
  final String loadingMessage;
  final int availableSeats;
  final String documentId;
  final InterprovincialStatus status;
  final InterprovincialRouteEntity route;
  final DateTime routeStartDateTime;
  DataInterprovincialDriverState({@required this.route, @required this.documentId, @required this.status, this.loadingMessage, @required this.routeStartDateTime, @required this.availableSeats});

  factory DataInterprovincialDriverState.initial({String loadingMessage}){
    return DataInterprovincialDriverState(
      status: InterprovincialStatus.loading,
      documentId: null,
      route: null,
      routeStartDateTime: null,
      availableSeats: null,
      loadingMessage: loadingMessage ?? 'Cargando'
    );
  }

  DataInterprovincialDriverState copyWith({String loadingMessage, String documentId, InterprovincialStatus status, InterprovincialRouteEntity route, DateTime routeStartDateTime, int availableSeats}){
    return DataInterprovincialDriverState(
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

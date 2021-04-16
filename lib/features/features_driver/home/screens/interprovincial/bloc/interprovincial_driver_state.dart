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
  final InterprovincialRouteInServiceEntity routeService;
  final DateTime routeStartDateTime;
  DataInterprovincialDriverState({@required this.routeService, @required this.documentId, @required this.status, this.loadingMessage, @required this.routeStartDateTime, @required this.availableSeats});

  factory DataInterprovincialDriverState.initial({String loadingMessage}){
    return DataInterprovincialDriverState(
      status: InterprovincialStatus.loading,
      documentId: null,
      routeService: null,
      routeStartDateTime: null,
      availableSeats: null,
      loadingMessage: loadingMessage ?? 'Cargando'
    );
  }

  DataInterprovincialDriverState copyWith({String loadingMessage, String documentId, InterprovincialStatus status, InterprovincialRouteInServiceEntity routeService, DateTime routeStartDateTime, int availableSeats}){
    return DataInterprovincialDriverState(
      loadingMessage: loadingMessage ?? this.loadingMessage,
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      routeService: routeService ?? this.routeService,
      routeStartDateTime: routeStartDateTime ?? this.routeStartDateTime,
      availableSeats: availableSeats ?? this.availableSeats,
    );
  }

  @override
  List<Object> get props => [routeService, status, documentId, loadingMessage, routeStartDateTime, availableSeats];
}

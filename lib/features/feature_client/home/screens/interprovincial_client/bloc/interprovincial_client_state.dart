part of 'interprovincial_client_bloc.dart';

abstract class InterprovincialClientState extends Equatable {
  const InterprovincialClientState();
  
  @override
  List<Object> get props => [];
}

enum InterprovincialClientStatus {
  loading, notEstablished, selectedRoute, searchInterprovincial
}
class DataInterprovincialClientState extends InterprovincialClientState {
  final InterprovincialClientStatus status;
  final String loadingMessage;
  final InterprovincialRouteInServiceEntity interprovincialRoute;
  DataInterprovincialClientState({ this.loadingMessage, this.status, this.interprovincialRoute});

  factory DataInterprovincialClientState.initial({String loadingMessage}){
    return DataInterprovincialClientState(
      status: InterprovincialClientStatus.loading,
      loadingMessage: loadingMessage ?? 'Cargando',
      interprovincialRoute: null
    );
  }

  DataInterprovincialClientState copyWith({InterprovincialClientStatus status, String loadingMessage, InterprovincialRouteInServiceEntity interprovincialRoute}){
    return DataInterprovincialClientState(
      status: status ?? this.status,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      interprovincialRoute: interprovincialRoute ?? this.interprovincialRoute,
    );
  }

  @override
  List<Object> get props => [status, loadingMessage, interprovincialRoute];
}

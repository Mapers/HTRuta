part of 'interprovincial_client_bloc.dart';

abstract class InterprovincialClientState extends Equatable {
  const InterprovincialClientState();
  
  @override
  List<Object> get props => [];
}

enum InteprovincialClientStatus {
  loading, notEstablished, selectedRoute, searchInterprovincial
}
class DataInterprovincialClientState extends InterprovincialClientState {
  final InteprovincialClientStatus status;
  final String loadingMessage;
  final InterprovincialRouteInServiceEntity interprovincialRoute;
  DataInterprovincialClientState({@required this.loadingMessage, @required this.status, @required this.interprovincialRoute});

  factory DataInterprovincialClientState.initial({String loadingMessage}){
    return DataInterprovincialClientState(
      status: InteprovincialClientStatus.loading,
      loadingMessage: loadingMessage ?? 'Cargando',
      interprovincialRoute: null
    );
  }

  DataInterprovincialClientState copyWith({InteprovincialClientStatus status, String loadingMessage, InterprovincialRouteInServiceEntity interprovincialRoute}){
    return DataInterprovincialClientState(
      status: status ?? this.status,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      interprovincialRoute: interprovincialRoute ?? this.interprovincialRoute,
    );
  }

  @override
  List<Object> get props => [status, loadingMessage, interprovincialRoute];
}

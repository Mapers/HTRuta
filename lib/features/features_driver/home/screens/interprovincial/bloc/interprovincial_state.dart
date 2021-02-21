part of 'interprovincial_bloc.dart';

abstract class InterprovincialState extends Equatable {
  const InterprovincialState();
  
  @override
  List<Object> get props => [];
}

enum InterprovincialStatus {
  loading, notEstablished, waiting, inRoute, 
}

class DataInterprovincialState extends InterprovincialState {
  final String loadingMessage;
  final InterprovincialStatus status;
  final InterprovincialRouteEntity route;
  DataInterprovincialState({@required this.route, @required this.status, this.loadingMessage});

  factory DataInterprovincialState.initial({String loadingMessage}){
    return DataInterprovincialState(
      status: InterprovincialStatus.loading,
      route: null,
      loadingMessage: loadingMessage ?? 'Cargando'
    );
  }

  @override
  List<Object> get props => [route, status, loadingMessage];
}

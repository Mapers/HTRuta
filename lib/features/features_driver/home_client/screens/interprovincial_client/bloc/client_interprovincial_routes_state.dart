part of 'client_interprovincial_routes_bloc.dart';

abstract class ClientInterprovincialRoutesState extends Equatable {
  const ClientInterprovincialRoutesState();
  
  @override
  List<Object> get props => [];
}

class LoadingClientInterprovincialRoutes extends ClientInterprovincialRoutesState {}

class DataClientInterprovincialRoutes extends ClientInterprovincialRoutesState {
  final  List<ClientInterporvincialRoutesEntity> routesFound;
  DataClientInterprovincialRoutes({@required this.routesFound});
  @override
  List<Object> get props => [routesFound];
}

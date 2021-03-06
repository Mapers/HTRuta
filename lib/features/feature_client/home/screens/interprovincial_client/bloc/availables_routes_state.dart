part of 'availables_routes_bloc.dart';

abstract class AvailablesRoutesState extends Equatable {
  const AvailablesRoutesState();
  @override
  List<Object> get props => [];
}

class LoadingAvailablesRoutes extends AvailablesRoutesState {}

class DataAvailablesRoutes extends AvailablesRoutesState {
  final List<AvailableRouteEntity> availablesRoutes;
  DataAvailablesRoutes({ this.availablesRoutes });
  @override
  List<Object> get props => [availablesRoutes];
}


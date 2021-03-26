part of 'availables_routes_bloc.dart';

abstract class AvailablesRoutesState extends Equatable {
  const AvailablesRoutesState();
  @override
  List<Object> get props => [];
}

class LoadingAvailablesRoutes extends AvailablesRoutesState {}

class DataAvailablesRoutes extends AvailablesRoutesState {
  final String distictfrom;
  final String distictTo;
  final int requiredSeats;
  final List<AvailableRouteEntity> availablesRoutes;
  DataAvailablesRoutes({ this.availablesRoutes,this.distictfrom, this.distictTo,this.requiredSeats});
  @override
  List<Object> get props => [availablesRoutes,distictfrom,distictTo,requiredSeats];
}


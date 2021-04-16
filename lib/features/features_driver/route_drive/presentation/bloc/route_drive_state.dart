part of 'route_drive_bloc.dart';

abstract class RouteDriveState extends Equatable {
  const RouteDriveState();
  @override
  List<Object> get props => [];

}
class RouteDriveInitial extends RouteDriveState {
  final List<InterprovincialRouteEntity> routerDrives;
  RouteDriveInitial({@required this.routerDrives});
  @override
  List<Object> get props => [routerDrives];
}
class LoadingRouteDriveState extends RouteDriveState {
  @override
  List<Object> get props => [];
}

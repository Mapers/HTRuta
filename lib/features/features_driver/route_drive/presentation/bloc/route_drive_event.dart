part of 'route_drive_bloc.dart';

abstract class RouteDriveEvent extends Equatable{
  const RouteDriveEvent();
  @override
  List<Object> get props => [];
}

class GetRouterDrivesEvent extends RouteDriveEvent{
}
class AddDrivesRouteDriveEvent extends RouteDriveEvent{
  final RouteEntity routerDrive;
  AddDrivesRouteDriveEvent({ @required this.routerDrive});
  @override
  List<Object> get props => [routerDrive];
}
class EditDrivesRouteDriveEvent extends RouteDriveEvent{
  final RouteEntity routerDrive;
  final RouteEntity newRouterDrive;
  EditDrivesRouteDriveEvent({@required this.newRouterDrive,@required this.routerDrive});
  @override
  List<Object> get props => [routerDrive,newRouterDrive];
}
class DeleteDrivesRouteDriveEvent extends RouteDriveEvent{
  final RouteEntity routerDrive;
  DeleteDrivesRouteDriveEvent({ @required this.routerDrive});
  @override
  List<Object> get props => [routerDrive];
}



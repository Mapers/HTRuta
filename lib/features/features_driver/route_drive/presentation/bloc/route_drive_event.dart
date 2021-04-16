part of 'route_drive_bloc.dart';

abstract class RouteDriveEvent extends Equatable{
  const RouteDriveEvent();
  @override
  List<Object> get props => [];
}

class GetRouterDrivesEvent extends RouteDriveEvent{
}
class AddDrivesRouteDriveEvent extends RouteDriveEvent{
  final InterprovincialRouteEntity routerDrive;
  AddDrivesRouteDriveEvent({ @required this.routerDrive});
  @override
  List<Object> get props => [routerDrive];
}
class EditDrivesRouteDriveEvent extends RouteDriveEvent{
  final InterprovincialRouteEntity routerDrive;
  EditDrivesRouteDriveEvent({@required this.routerDrive});
  @override
  List<Object> get props => [ routerDrive ];
}
class DeleteDrivesRouteDriveEvent extends RouteDriveEvent{
  final InterprovincialRouteEntity routerDrive;
  DeleteDrivesRouteDriveEvent({ @required this.routerDrive});
  @override
  List<Object> get props => [routerDrive];
}



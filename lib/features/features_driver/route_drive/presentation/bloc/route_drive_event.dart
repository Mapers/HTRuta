part of 'route_drive_bloc.dart';

abstract class RouteDriveEvent extends Equatable{
  const RouteDriveEvent();
  @override
  List<Object> get props => [];
}

class GetRouterDrivesEvent extends RouteDriveEvent{
}
class AddDrivesRouteDriveEvent extends RouteDriveEvent{
  final RoutesEntity roterDrive;
  AddDrivesRouteDriveEvent({ @required this.roterDrive,});
  @override
  List<Object> get props => [roterDrive];
}
class EditDrivesRouteDriveEvent extends RouteDriveEvent{
  final RoutesEntity roterDrive;
  final RoutesEntity newRoterDrive;
  EditDrivesRouteDriveEvent({@required this.newRoterDrive,@required this.roterDrive});
  @override
  List<Object> get props => [roterDrive,newRoterDrive];
}
class DeleteDrivesRouteDriveEvent extends RouteDriveEvent{
  final RoutesEntity roterDrive;
  DeleteDrivesRouteDriveEvent({ @required this.roterDrive});
  @override
  List<Object> get props => [roterDrive];
}



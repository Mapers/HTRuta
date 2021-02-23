part of 'route_drive_bloc.dart';

abstract class RouteDriveEvent extends Equatable{
  const RouteDriveEvent();
  @override
  List<Object> get props => [];
}

class GetRouterDrivesEvent extends RouteDriveEvent{
}
class AddDrivesRouteDriveEvent extends RouteDriveEvent{
  final RoterDriveEntity roterDrive;
  AddDrivesRouteDriveEvent({ @required this.roterDrive,});
  @override
  List<Object> get props => [roterDrive];
}
class EditDrivesRouteDriveEvent extends RouteDriveEvent{
  final RoterDriveEntity roterDrive;
  final RoterDriveEntity newRoterDrive;
  EditDrivesRouteDriveEvent({@required this.newRoterDrive,@required this.roterDrive});
  @override
  List<Object> get props => [roterDrive,newRoterDrive];
}
class DeleteDrivesRouteDriveEvent extends RouteDriveEvent{
  final RoterDriveEntity roterDrive;
  DeleteDrivesRouteDriveEvent({ @required this.roterDrive});
  @override
  List<Object> get props => [roterDrive];
}



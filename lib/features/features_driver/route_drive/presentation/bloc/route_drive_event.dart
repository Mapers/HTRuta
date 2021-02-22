part of 'route_drive_bloc.dart';

abstract class RouteDriveEvent extends Equatable{
  const RouteDriveEvent();
  @override
  List<Object> get props => [];
}

class GetRouterDrivesEvent extends RouteDriveEvent{
}
class AddDrivesRouteDriveEvent extends RouteDriveEvent{

  @override
  List<Object> get props => [];
}



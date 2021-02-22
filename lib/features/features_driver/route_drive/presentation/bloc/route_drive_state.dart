part of 'route_drive_bloc.dart';

abstract class RouteDriveState extends Equatable {
  const RouteDriveState();
  @override
  List<Object> get props => [];

}
class RouteDriveInitial extends RouteDriveState {
  final List<RoterDriveEntity> roterDrives;
  RouteDriveInitial({this.roterDrives});
  @override
  List<Object> get props => [roterDrives];
}

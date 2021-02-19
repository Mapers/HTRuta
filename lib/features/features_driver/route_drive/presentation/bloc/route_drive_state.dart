part of 'route_drive_bloc.dart';
@immutable
abstract class RouteDriveState extends Equatable {}
class RouteDriveInitial extends RouteDriveState {
  final List<RoterDriveEntity> roterDrives;
  RouteDriveInitial({this.roterDrives});
  @override
  List<Object> get props => [roterDrives];
}

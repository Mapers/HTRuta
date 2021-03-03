import 'dart:async';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'route_drive_event.dart';
part 'route_drive_state.dart';
class RouteDriveBloc extends Bloc<RouteDriveEvent, RouteDriveState> {
  final RouteDriveRepository routeDriveRepository;
  RouteDriveBloc(this.routeDriveRepository) : super(LoadingRouteDriveState());
  @override
  Stream<RouteDriveState> mapEventToState(
    RouteDriveEvent event,
  ) async* {
    try {
      if (event is GetRouterDrivesEvent) {
        yield LoadingRouteDriveState();
        List<RoutesEntity> roterDrives = await routeDriveRepository.getRouterDrives();
        yield RouteDriveInitial(roterDrives: roterDrives );
      }else if(event is AddDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        List<RoutesEntity> roterDrives = await routeDriveRepository.addRouterDrives(roterDrive: event.roterDrive);
        yield RouteDriveInitial(roterDrives: roterDrives);
      }else if(event is EditDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        List<RoutesEntity> roterDrives = await routeDriveRepository.editRouterDrives( roterDrive: event.roterDrive,newRoterDrive: event.newRoterDrive);
        yield RouteDriveInitial(roterDrives: roterDrives);
      }else if(event is DeleteDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        List<RoutesEntity> roterDrives = await routeDriveRepository.deleteRouterDrives(roterDrive: event.roterDrive);
        yield RouteDriveInitial(roterDrives: roterDrives);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

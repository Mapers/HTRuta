import 'dart:async';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
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
        List<RouteEntity> roterDrives = await routeDriveRepository.getRouterDrives();
        yield RouteDriveInitial(routerDrives: roterDrives );
      }else if(event is AddDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        List<RouteEntity> roterDrives = await routeDriveRepository.addRouterDriveRepository(roterDrive: event.routerDrive,);
        yield RouteDriveInitial(routerDrives: roterDrives);
      }else if(event is EditDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        List<RouteEntity> roterDrives = await routeDriveRepository.editRouterDrives( roterDrive: event.routerDrive,newRoterDrive: event.newRouterDrive);
        yield RouteDriveInitial(routerDrives: roterDrives);
      }else if(event is DeleteDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        List<RouteEntity> roterDrives = await routeDriveRepository.deleteRouterDrives(roterDrive: event.routerDrive);
        yield RouteDriveInitial(routerDrives: roterDrives);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

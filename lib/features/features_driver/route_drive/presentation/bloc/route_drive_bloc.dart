import 'dart:async';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
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
        List<InterprovincialRouteEntity> interprovincialRoutes = await routeDriveRepository.getRouterDrives();
        yield RouteDriveInitial(routerDrives: interprovincialRoutes);
      }else if(event is AddDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        await routeDriveRepository.addRouterDriveRepository(interprovincialRoute: event.routerDrive,);
        List<InterprovincialRouteEntity> interprovincialRoutes = await routeDriveRepository.getRouterDrives();
        yield RouteDriveInitial(routerDrives: interprovincialRoutes);
      }else if(event is EditDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        await routeDriveRepository.editRouterDrives( interprovincialRoute: event.routerDrive);
        List<InterprovincialRouteEntity> interprovincialRoutes = await routeDriveRepository.getRouterDrives();
        yield RouteDriveInitial(routerDrives: interprovincialRoutes);
      }else if(event is DeleteDrivesRouteDriveEvent) {
        yield LoadingRouteDriveState();
        await routeDriveRepository.deleteRouterDrives( interprovincialRoute: event.routerDrive);
        List<InterprovincialRouteEntity> interprovincialRoutes = await routeDriveRepository.getRouterDrives();
        yield RouteDriveInitial(routerDrives: interprovincialRoutes);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

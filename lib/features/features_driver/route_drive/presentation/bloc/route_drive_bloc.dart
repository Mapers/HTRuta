import 'dart:async';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/fromToEntity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
part 'route_drive_event.dart';
part 'route_drive_state.dart';
class RouteDriveBloc extends Bloc<RouteDriveEvent, RouteDriveState> {
  final RouteDriveRepository routeDriveRepository;
  RouteDriveBloc(this.routeDriveRepository) : super(RouteDriveInitial(roterDrives: []));
  @override
  Stream<RouteDriveState> mapEventToState(
    RouteDriveEvent event,
  ) async* {
    if (event is GetRouterDrivesEvent) {
      List<RoterDriveEntity> roterDrives = await routeDriveRepository.getRouterDrives();
      yield RouteDriveInitial(roterDrives: roterDrives );
    }else if (event is AddDrivesRouteDriveEvent) {
      List<RoterDriveEntity> roterDrives = await routeDriveRepository.addRouterDrives(name: event.name, dataFromTo: event.dataFromTo);
      print(".......ccc");
      print(roterDrives.length);
      yield RouteDriveInitial(roterDrives: roterDrives );
    }
  }
}

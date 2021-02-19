import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'route_drive_event.dart';
part 'route_drive_state.dart';
class RouteDriveBloc extends Bloc<RouteDriveEvent, RouteDriveState> {
  RouteDriveBloc() : super(RouteDriveInitial());
  @override
  Stream<RouteDriveState> mapEventToState(
    RouteDriveEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

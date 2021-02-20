import 'dart:async';

import 'package:HTRuta/features/DriverTaxiApp/enums/type_service_driver_enum.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'driver_service_event.dart';
part 'driver_service_state.dart';

class DriverServiceBloc extends Bloc<DriverServiceEvent, DriverServiceState> {
  DriverServiceBloc() : super(DataDriverServiceState.initial());

  @override
  Stream<DriverServiceState> mapEventToState(
    DriverServiceEvent event,
  ) async* {
    if(event is ChangeDriverServiceEvent){
      DataDriverServiceState current = state;
      yield current.copyWith(typeService: event.type);
    }
  }
}
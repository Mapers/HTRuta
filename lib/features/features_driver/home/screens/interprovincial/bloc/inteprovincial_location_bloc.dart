import 'dart:async';

import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'inteprovincial_location_event.dart';
part 'inteprovincial_location_state.dart';

class InterprovincialLocationBloc extends Bloc<InterprovincialLocationEvent, InterprovincialLocationState> {
  InterprovincialLocationBloc() : super(DataInteprovincialLocationState.initial());

  @override
  Stream<InterprovincialLocationState> mapEventToState(
    InterprovincialLocationEvent event,
  ) async* {
    if(event is UpdateDriverLocationInterprovincialLocationEvent){
      DataInteprovincialLocationState data = state;
      yield data.copyWith(
        driver: event.driverLocation
      );
    }else if(event is SetPassengerSelectedInterprovincialLocationEvent){
      DataInteprovincialLocationState data = state;
      yield data.copyWith(
        passengerSelected: event.passenger
      );
    }else if(event is RemovePassengerSelectedInterprovincialLocationEvent){
      DataInteprovincialLocationState data = state;
      yield data.copyWithPassengerNull();
    }
  }
}

import 'dart:async';

import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'inteprovincial_location_event.dart';
part 'inteprovincial_location_state.dart';

class InterprovincialLocationBloc extends Bloc<InterprovincialLocationEvent, InterprovincialLocationState> {
  final InterprovincialDataRemote interprovincialDataRemote;
  InterprovincialLocationBloc({@required this.interprovincialDataRemote}) : super(DataInteprovincialLocationState.initial());

  @override
  Stream<InterprovincialLocationState> mapEventToState(
    InterprovincialLocationEvent event,
  ) async* {
    if(event is UpdateDriverLocationInterprovincialLocationEvent){
      DataInteprovincialLocationState data = state;
      if(event.status == InterprovincialStatus.inRoute){
        if(data.documentId != null){
          interprovincialDataRemote.updateLocationInService(documentId: data.documentId, location: event.driverLocation);
        }
      }
      yield data.copyWith(
        location: event.driverLocation
      );
    }else if(event is SetPassengerSelectedInterprovincialLocationEvent){
      DataInteprovincialLocationState data = state;
      yield data.copyWith(
        passengerSelected: event.passenger
      );
    }else if(event is RemovePassengerSelectedInterprovincialLocationEvent){
      DataInteprovincialLocationState data = state;
      yield data.copyWithPassengerNull();
    }else if(event is SetDocumentIdInterprovincialLocationEvent){
      if(event.documentId != null){
        DataInteprovincialLocationState data = state;
        if(data.documentId != event.documentId){
          yield data.copyWith(documentId: event.documentId);
        }
      }
    }
  }
}

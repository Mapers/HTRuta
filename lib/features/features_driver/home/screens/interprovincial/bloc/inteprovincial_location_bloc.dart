import 'dart:async';

import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'inteprovincial_location_event.dart';
part 'inteprovincial_location_state.dart';

class InterprovincialDriverLocationBloc extends Bloc<InterprovincialDriverLocationEvent, InterprovincialDriverLocationState> {
  final InterprovincialDataRemote interprovincialDataRemote;
  final InterprovincialDataDriverFirestore interprovincialDataFirestore;
  InterprovincialDriverLocationBloc({@required this.interprovincialDataRemote, @required this.interprovincialDataFirestore}) : super(DataInteprovincialDriverLocationState.initial());

  @override
  Stream<InterprovincialDriverLocationState> mapEventToState(
    InterprovincialDriverLocationEvent event,
  ) async* {
    if(event is UpdateDriverLocationInterprovincialDriverLocationEvent){
      DataInteprovincialDriverLocationState data = state;
      if(event.status == InterprovincialStatus.inRoute){
        if(data.documentId != null){
          interprovincialDataFirestore.updateLocationInService(documentId: data.documentId, location: event.driverLocation);
        }
      }
      yield data.copyWith(
        location: event.driverLocation
      );
    }else if(event is SetPassengerSelectedInterprovincialDriverLocationEvent){
      DataInteprovincialDriverLocationState data = state;
      yield data.copyWith(
        passengerSelected: event.passenger
      );
    }else if(event is RemovePassengerSelectedInterprovincialDriverLocationEvent){
      DataInteprovincialDriverLocationState data = state;
      yield data.copyWithPassengerNull();
    }else if(event is SetDocumentIdInterprovincialDriverLocationEvent){
      if(event.documentId != null){
        DataInteprovincialDriverLocationState data = state;
        if(data.documentId != event.documentId){
          yield data.copyWith(documentId: event.documentId);
        }
      }
    }
  }
}

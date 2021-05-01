import 'dart:async';

import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'interprovincial_location_event.dart';
part 'interprovincial_location_state.dart';

class InterprovincialDriverLocationBloc extends Bloc<InterprovincialDriverLocationEvent, InterprovincialDriverLocationState> {
  final InterprovincialDataDriverFirestore interprovincialDataFirestore;
  InterprovincialDriverLocationBloc({@required this.interprovincialDataFirestore}) : super(DataInterprovincialDriverLocationState.initial());

  @override
  Stream<InterprovincialDriverLocationState> mapEventToState(
    InterprovincialDriverLocationEvent event,
  ) async* {
    if(event is UpdateDriverLocationInterprovincialDriverLocationEvent){
      DataInterprovincialDriverLocationState data = state;
      if(event.status == InterprovincialStatus.inRoute){
        if(data.documentId != null){
          interprovincialDataFirestore.updateLocationInService(documentId: data.documentId, location: event.driverLocation);
        }
      }
      yield data.copyWith(
        location: event.driverLocation
      );
    }else if(event is SetPassengerSelectedInterprovincialDriverLocationEvent){
      DataInterprovincialDriverLocationState data = state;
      yield data.copyWith(
        passengerSelected: event.passenger
      );
    }else if(event is RemovePassengerSelectedInterprovincialDriverLocationEvent){
      DataInterprovincialDriverLocationState data = state;
      yield data.copyWithPassengerNull();
    }else if(event is SetDocumentIdInterprovincialDriverLocationEvent){
      if(event.documentId != null){
        DataInterprovincialDriverLocationState data = state;
        if(data.documentId != event.documentId){
          yield data.copyWith(documentId: event.documentId);
        }
      }
    }
  }
}

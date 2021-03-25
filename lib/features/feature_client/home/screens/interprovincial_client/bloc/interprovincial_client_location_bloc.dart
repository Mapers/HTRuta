import 'dart:async';

import 'package:HTRuta/entities/location_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'interprovincial_client_location_event.dart';
part 'interprovincial_client_location_state.dart';

class InterprovincialClientLocationBloc extends Bloc<InterprovincialClientLocationEvent, InterprovincialClientLocationState> {
  InterprovincialClientLocationBloc() : super(DataInterprovincialClientLocationState.initial());

  @override
  Stream<InterprovincialClientLocationState> mapEventToState(
    InterprovincialClientLocationEvent event,
  ) async* {
    if(event is UpdateInterprovincialClientLocationEvent){
      DataInterprovincialClientLocationState data = state;
      // if(event.status == InterprovincialStatus.inRoute){
      //   if(data.documentId != null){
      //     interprovincialDataRemote.updateLocationInService(documentId: data.documentId, location: event.driverLocation);
      //   }
      // }
      yield data.copyWith(
        location: event.driverLocation
      );
    }else if(event is SetDriverSelectedInterprovincialClientLocationEvent){
      DataInterprovincialClientLocationState data = state;
      yield data.copyWith(
        driverSelected: event.driver
      );
    }else if(event is SetDocumentIdInterprovincialClientLocationEvent){
      if(event.documentId != null){
        DataInterprovincialClientLocationState data = state;
        if(data.documentId != event.documentId){
          yield data.copyWith(documentId: event.documentId);
        }
      }
    }
  }
}

import 'dart:async';

import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'interprovincial_driver_event.dart';
part 'interprovincial_driver_state.dart';

class InterprovincialDriverBloc extends Bloc<InterprovincialDriverEvent, InterprovincialState> {
  final InterprovincialDataRemote interprovincialDataRemote;
  InterprovincialDriverBloc({@required this.interprovincialDataRemote}) : super(DataInterprovincialDriverState.initial());

  @override
  Stream<InterprovincialState> mapEventToState(
    InterprovincialDriverEvent event,
  ) async* {
    if(event is GetDataInterprovincialDriverEvent){
      yield DataInterprovincialDriverState.initial();
      await Future.delayed(Duration(seconds: 1));
      yield DataInterprovincialDriverState.initial().copyWith(
        status: InterprovincialStatus.notEstablished
      );
    }else if(event is SelectRouteInterprovincialDriverEvent){
      yield DataInterprovincialDriverState.initial(loadingMessage: 'Seleccionando ruta');
      String documentId = await interprovincialDataRemote.createStartService(
        route: event.route,
        routeStartDateTime: event.dateTime,
        status: InterprovincialStatus.onWhereabouts,
        availableSeats: event.availableSeats
      );
      yield DataInterprovincialDriverState(
        route: event.route,
        status: InterprovincialStatus.onWhereabouts,
        routeStartDateTime: event.dateTime,
        documentId: documentId,
        availableSeats: event.availableSeats
      );
    }else if(event is StartRouteInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      yield data.copyWith(loadingMessage: 'Iniciando ruta', status: InterprovincialStatus.loading);
      await interprovincialDataRemote.changeToStartRouteInService(documentId: data.documentId, status: InterprovincialStatus.inRoute);
      yield data.copyWith(
        status: InterprovincialStatus.inRoute
      );
    }else if(event is PlusOneAvailabelSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      if(data.availableSeats < event.maxSeats){
        int newAvailableSeats = data.availableSeats + 1;
        await interprovincialDataRemote.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats);
        yield data.copyWith(
          availableSeats: newAvailableSeats
        );
      }
    }else if(event is MinusOneAvailabelSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      if(data.availableSeats > 0){
        int newAvailableSeats = data.availableSeats - 1;
        await interprovincialDataRemote.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats);
        yield data.copyWith(
          availableSeats: newAvailableSeats
        );
      }
    }
  }
}

import 'dart:async';

import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'interprovincial_event.dart';
part 'interprovincial_state.dart';

class InterprovincialBloc extends Bloc<InterprovincialEvent, InterprovincialState> {
  final InterprovincialDataRemote interprovincialDataRemote;
  InterprovincialBloc({@required this.interprovincialDataRemote}) : super(DataInterprovincialState.initial());

  @override
  Stream<InterprovincialState> mapEventToState(
    InterprovincialEvent event,
  ) async* {
    if(event is GetDataInterprovincialEvent){
      yield DataInterprovincialState.initial();
      await Future.delayed(Duration(seconds: 1));
      yield DataInterprovincialState.initial().copyWith(
        status: InterprovincialStatus.notEstablished
      );
    }else if(event is SelectRouteInterprovincialEvent){
      yield DataInterprovincialState.initial(loadingMessage: 'Seleccionando ruta');
      String documentId = await interprovincialDataRemote.createStartService(
        route: event.route,
        routeStartDateTime: event.dateTime,
        status: InterprovincialStatus.onWhereabouts,
        availableSeats: event.availableSeats
      );
      yield DataInterprovincialState(
        route: event.route,
        status: InterprovincialStatus.onWhereabouts,
        routeStartDateTime: event.dateTime,
        documentId: documentId,
        availableSeats: event.availableSeats
      );
    }else if(event is StartRouteInterprovincialEvent){
      DataInterprovincialState data = state;
      yield data.copyWith(loadingMessage: 'Iniciando ruta', status: InterprovincialStatus.loading);
      await interprovincialDataRemote.changeToStartRouteInService(documentId: data.documentId, status: InterprovincialStatus.inRoute);
      yield data.copyWith(
        status: InterprovincialStatus.inRoute
      );
    }else if(event is PlusOneAvailabelSeatInterprovincialEvent){
      DataInterprovincialState data = state;
      if(data.availableSeats < event.maxSeats){
        int newAvailableSeats = data.availableSeats + 1;
        await interprovincialDataRemote.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats);
        yield data.copyWith(
          availableSeats: newAvailableSeats
        );
      }
    }else if(event is MinusOneAvailabelSeatInterprovincialEvent){
      DataInterprovincialState data = state;
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

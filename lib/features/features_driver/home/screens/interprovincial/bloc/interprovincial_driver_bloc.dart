import 'dart:async';

import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

part 'interprovincial_driver_event.dart';
part 'interprovincial_driver_state.dart';

class InterprovincialDriverBloc extends Bloc<InterprovincialDriverEvent, InterprovincialDriverState> {
  final InterprovincialDriverDataRemote interprovincialDriverDataRemote;
  final InterprovincialDataDriverFirestore interprovincialDataFirestore;
  InterprovincialDriverBloc({@required this.interprovincialDataFirestore, @required this.interprovincialDriverDataRemote}) : super(DataInterprovincialDriverState.initial());

  @override
  Stream<InterprovincialDriverState> mapEventToState(
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
      try {
        String documentId = await interprovincialDataFirestore.createStartService(
          interprovincialRoute: event.interprovincialRoute,
          routeStartDateTime: event.dateTime,
          status: InterprovincialStatus.onWhereabouts,
          availableSeats: event.availableSeats
        );
        String serviceId = await interprovincialDriverDataRemote.createService(
          availableSeats: event.availableSeats,
          documentId: documentId,
          interprovincialRoute: event.interprovincialRoute,
          startDateTime: event.dateTime
        );
        final _session = Session();
        final dataUsuario = await _session.get();
        yield DataInterprovincialDriverState(
          routeService: InterprovincialRouteInServiceEntity.fromRoute(
            id: serviceId,
            driverName: dataUsuario.fullNames,
            //? Considerar ignorar en driver
            starts: -1,
            interprovincialRoute: event.interprovincialRoute
          ),
          status: InterprovincialStatus.onWhereabouts,
          routeStartDateTime: event.dateTime,
          documentId: documentId,
          availableSeats: event.availableSeats
        );
      } on ServerException catch (e) {
        Fluttertoast.showToast(msg: 'No se pudo realizar esta acción. ${e.message}', toastLength: Toast.LENGTH_SHORT);
        yield DataInterprovincialDriverState.initial().copyWith(
          status: InterprovincialStatus.notEstablished
        );
      }
    }else if(event is StartRouteInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      yield data.copyWith(loadingMessage: 'Iniciando ruta', status: InterprovincialStatus.loading);
      await interprovincialDataFirestore.changeToStartRouteInService(documentId: data.documentId, status: InterprovincialStatus.inRoute);
      yield data.copyWith(
        status: InterprovincialStatus.inRoute
      );
    }else if(event is PlusOneAvailableSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      if(data.availableSeats < event.maxSeats){
        int newAvailableSeats = data.availableSeats + 1;
        await interprovincialDataFirestore.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats);
        yield data.copyWith(
          availableSeats: newAvailableSeats
        );
      }
    }else if(event is MinusOneAvailableSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      if(data.availableSeats > 0){
        int newAvailableSeats = data.availableSeats - 1;
        await interprovincialDataFirestore.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats);
        yield data.copyWith(
          availableSeats: newAvailableSeats
        );
      }
    }else if(event is SetLocalAvailabelSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      yield data.copyWith(availableSeats: event.newSeats);
    }
  }
}

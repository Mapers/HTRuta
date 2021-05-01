import 'dart:async';

import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_remote.dart';
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
  final ServiceDataRemote serviceDataRemote;
  InterprovincialDriverBloc({@required this.interprovincialDataFirestore, @required this.interprovincialDriverDataRemote, @required this.serviceDataRemote}) : super(DataInterprovincialDriverState.initial());

  @override
  Stream<InterprovincialDriverState> mapEventToState(
    InterprovincialDriverEvent event,
  ) async* {
    if(event is GetDataInterprovincialDriverEvent){
      DataInterprovincialDriverState prevState = state;
      if(prevState.documentId != null) return;

      yield DataInterprovincialDriverState.initial();
      try {
        if(event.documentId != null){
          DataInterprovincialDriverState newState = await interprovincialDataFirestore.getDataInterprovincialDriver(documentId: event.documentId);
          if(newState == null) throw LocalException(message: 'Documento no encontrado.');

          final routeService = await serviceDataRemote.getInterprovincialRouteInServiceById(newState.serviceId);
          yield newState.copyWith(routeService: routeService);
        }else{
          throw LocalException(message: 'Documento no encontrado.');
        }
      } catch (_) {
        yield DataInterprovincialDriverState.initial().copyWith(
          status: InterprovincialStatus.notEstablished
        );
      }
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
        await interprovincialDataFirestore.addServiceIdToDocumentService(
          documentId: documentId,
          serviceId: serviceId
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
          serviceId: serviceId,
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
      try {
        yield data.copyWith(loadingMessage: 'Iniciando ruta', status: InterprovincialStatus.loading);
        await Future.wait([
          interprovincialDataFirestore.changeToStartRouteInService(documentId: data.documentId, status: InterprovincialStatus.inRoute),
          interprovincialDriverDataRemote.changeToInRoute(serviceId: data.serviceId)
        ]);
        yield data.copyWith(
          status: InterprovincialStatus.inRoute
        );
      } on ServerException catch (e) {
        Fluttertoast.showToast(msg: 'No se pudo realizar esta acción. ${e.message}', toastLength: Toast.LENGTH_SHORT);
        interprovincialDataFirestore.changeToStartRouteInService(documentId: data.documentId, status: InterprovincialStatus.onWhereabouts);
        yield data;
      }
    }else if(event is PlusOneAvailableSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      if(data.availableSeats < event.maxSeats){
        int newAvailableSeats = data.availableSeats + 1;
        try {
          await Future.wait([
            interprovincialDataFirestore.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats),
            interprovincialDriverDataRemote.updateSeatsAvailable(serviceId: data.routeService.id, seatsAvailable: newAvailableSeats)
          ]);
          yield data.copyWith(
            availableSeats: newAvailableSeats
          );
        } on ServerException catch (e) {
          Fluttertoast.showToast(msg: 'No se pudo realizar esta acción. ${e.message}', toastLength: Toast.LENGTH_SHORT);
          yield data;
        }
      }
    }else if(event is MinusOneAvailableSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      if(data.availableSeats > 0){
        int newAvailableSeats = data.availableSeats - 1;
        try {
          await Future.wait([
            interprovincialDataFirestore.updateSeatsQuantity(documentId: data.documentId, availableSeats: newAvailableSeats),
            interprovincialDriverDataRemote.updateSeatsAvailable(serviceId: data.routeService.id, seatsAvailable: newAvailableSeats)
          ]);
          yield data.copyWith(
            availableSeats: newAvailableSeats
          );
        } on ServerException catch (e) {
          Fluttertoast.showToast(msg: 'No se pudo realizar esta acción. ${e.message}', toastLength: Toast.LENGTH_SHORT);
          yield data;
        }
      }
    }else if(event is SetLocalAvailabelSeatInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      yield data.copyWith(availableSeats: event.newSeats);
    }else if(event is FinishServiceInterprovincialDriverEvent){
      DataInterprovincialDriverState data = state;
      yield DataInterprovincialDriverState.initial();
      await Future.wait([
        interprovincialDataFirestore.finishService(documentId: data.documentId),
        interprovincialDriverDataRemote.finishService(serviceId: data.routeService.id)
      ]);
      yield DataInterprovincialDriverState.initial().copyWith(
        status: InterprovincialStatus.notEstablished
      );
      Fluttertoast.showToast(msg: 'Servicio culminado exitosamente.');
    }
  }
}

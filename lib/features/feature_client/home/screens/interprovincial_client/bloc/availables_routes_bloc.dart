import 'dart:async';

import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'availables_routes_event.dart';
part 'availables_routes_state.dart';

class AvailablesRoutesBloc extends Bloc<AvailablesRoutesEvent, AvailablesRoutesState> {
  final InterprovincialClientRemoteDataSoruce interprovincialClientRemote;
  AvailablesRoutesBloc(this.interprovincialClientRemote) : super(LoadingAvailablesRoutes());

  @override
  Stream<AvailablesRoutesState> mapEventToState(
    AvailablesRoutesEvent event,
  ) async* {
    if(event is GetAvailablesRoutesEvent){
      interprovincialClientRemote.getFiebaseAvailablesRoutes();
      yield LoadingAvailablesRoutes();
      List<AvailableRouteEntity> availablesRoutes = await interprovincialClientRemote.getAvailablesRoutes(from: event.from ,to: event.to,radio: event.radio,seating: event.seating);
      // List<AvailableRouteEntity> availablesRoutesFirebase = await interprovincialClientRemote.getFiebaseAvailablesRoutes();

      yield DataAvailablesRoutes(availablesRoutes: availablesRoutes,distictfrom: event.from.districtName,distictTo: event.to.districtName,requiredSeats: event.seating);
    }
  }
}

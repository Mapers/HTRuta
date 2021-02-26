import 'dart:async';

import 'package:HTRuta/features/features_driver/home_client/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/features_driver/home_client/entities/Client_interprovicial_routes_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'client_interprovincial_routes_event.dart';
part 'client_interprovincial_routes_state.dart';

class ClientInterprovincialRoutesBloc extends Bloc<ClientInterprovincialRoutesEvent, ClientInterprovincialRoutesState> {
  final InterprovincialClientRemoteDataSoruce interprovincialClientRemoteDataSoruce;
  ClientInterprovincialRoutesBloc({@required this.interprovincialClientRemoteDataSoruce}) : super(LoadingClientInterprovincialRoutes());

  @override
  Stream<ClientInterprovincialRoutesState> mapEventToState(
    ClientInterprovincialRoutesEvent event,
  ) async* {
    if(event is GetRoutesFoundClientInterprovincialRoutesEvent){
      yield LoadingClientInterprovincialRoutes();
      List<ClientInterporvincialRoutesEntity> routesFound  =  await interprovincialClientRemoteDataSoruce.getListRouterClient();
      yield DataClientInterprovincialRoutes(routesFound:routesFound);
    }
  }
}

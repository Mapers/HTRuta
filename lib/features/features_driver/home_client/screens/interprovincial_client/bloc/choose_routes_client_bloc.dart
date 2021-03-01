import 'dart:async';

import 'package:HTRuta/features/features_driver/home_client/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/features_driver/home_client/entities/privince_client_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'choose_routes_client_event.dart';
part 'choose_routes_client_state.dart';

class ChooseRoutesClientBloc extends Bloc<ChooseRoutesClientEvent, ChooseRoutesClientState> {
  final InterprovincialClientRemoteDataSoruce interprovincialClientRemoteDataSoruce;
  ChooseRoutesClientBloc(this.interprovincialClientRemoteDataSoruce) : super(LoadingChooseRoutesClient());

  @override
  Stream<ChooseRoutesClientState> mapEventToState(
    ChooseRoutesClientEvent event,
  ) async* {
    if(event is GetProvincesChooseRoutesClientEvent){
      yield LoadingChooseRoutesClient();
      List<ProvincesClientEntity> provinces = await interprovincialClientRemoteDataSoruce.getProvincesClient();
      yield DataChooseRoutesClient(provinces:provinces );
    }
  }
}

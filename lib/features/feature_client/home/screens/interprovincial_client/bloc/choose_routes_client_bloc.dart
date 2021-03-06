import 'dart:async';

import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
      List<ProvinceDistrictClientEntity> provinces = await interprovincialClientRemoteDataSoruce.getProvincesClient();
      yield DataChooseRoutesClient(provinceDistricts:provinces );
    }
  }
}

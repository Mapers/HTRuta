import 'dart:async';

import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/availables_routes_enity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      yield LoadingAvailablesRoutes();
      List<AvailablesRoutesEntity> availablesRoutes = await interprovincialClientRemote.getAvailablesRoutes();
      yield DataAvailablesRoutes(availablesRoutes: availablesRoutes);
    }
  }
}

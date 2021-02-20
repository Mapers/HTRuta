import 'dart:async';

import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'interprovincial_event.dart';
part 'interprovincial_state.dart';

class InterprovincialBloc extends Bloc<InterprovincialEvent, InterprovincialState> {
  final InterprovincialDataRemote interprovincialDataRemote;
  InterprovincialBloc({@required this.interprovincialDataRemote}) : super(DataInterprovincialState());

  @override
  Stream<InterprovincialState> mapEventToState(
    InterprovincialEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

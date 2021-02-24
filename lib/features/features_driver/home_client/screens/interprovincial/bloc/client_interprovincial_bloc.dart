import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'interprovincial_event.dart';
part 'interprovincial_state.dart';
class InterprovincialBloc extends Bloc<InterprovincialEvent, InterprovincialState> {
  InterprovincialBloc() : super(InterprovincialInitial());
  @override
  Stream<InterprovincialState> mapEventToState(
    InterprovincialEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'stateinput_event.dart';
part 'stateinput_state.dart';

class StateinputBloc extends Bloc<StateinputEvent, StateinputState> {
  StateinputBloc() : super(StateinputInitial(stateSelect: true,markers: {}));
  Map<MarkerId, Marker> _markers = {};
  @override
  Stream<StateinputState> mapEventToState(
    StateinputEvent event,
  ) async* {
    if(event is IsStateinputEvent){
      StateinputInitial param = state;
      yield StateinputInitial(stateSelect: event.isStateSelect,markers: param.markers);
    }else if(event is AddMarkerStateinputEvent ){
      _markers[event.markers.markerId] = event.markers;
      StateinputInitial param = state;
      yield StateinputInitial(stateSelect: param.stateSelect, markers: _markers);
    }
  }
}

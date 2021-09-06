part of 'stateinput_bloc.dart';

abstract class StateinputState extends Equatable {
  const StateinputState();
  @override
  List<Object> get props => [];
}

class StateinputInitial extends StateinputState {
  final bool stateSelect;
  final Map<MarkerId, Marker> markers;
  StateinputInitial({this.markers,this.stateSelect});
  @override
  List<Object> get props => [stateSelect, markers];
}

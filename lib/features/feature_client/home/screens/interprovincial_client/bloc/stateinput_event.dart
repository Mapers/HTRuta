part of 'stateinput_bloc.dart';

abstract class StateinputEvent extends Equatable {
  const StateinputEvent();

  @override
  List<Object> get props => [];
}


class IsStateinputEvent extends StateinputEvent {
  final bool isStateSelect;
  IsStateinputEvent({this.isStateSelect});
}
class AddMarkerStateinputEvent extends StateinputEvent{
  final Marker  markers;
  AddMarkerStateinputEvent({this.markers});
  @override
  List<Object> get props => [markers];
}
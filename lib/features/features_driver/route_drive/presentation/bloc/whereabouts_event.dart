part of 'whereabouts_bloc.dart';

abstract class WhereaboutsEvent extends Equatable {
  const WhereaboutsEvent();

  @override
  List<Object> get props => [];
}
class GetwhereaboutsWhereaboutsEvent extends WhereaboutsEvent{}

class OnReorderwhereaboutsWhereaboutsEvent extends WhereaboutsEvent{
  final int oldIndex;
  final int newIndex;
  
  OnReorderwhereaboutsWhereaboutsEvent({this.oldIndex, this.newIndex});
  @override
  List<Object> get props => [oldIndex,newIndex];
}
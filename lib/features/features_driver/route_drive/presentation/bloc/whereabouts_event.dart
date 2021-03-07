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
class AddwhereaboutsWhereaboutsEvent extends WhereaboutsEvent{
  final LocationEntity whereabouts;
  final String cost;
  AddwhereaboutsWhereaboutsEvent({@required this.whereabouts,@required this.cost });
  @override
  List<Object> get props => [whereabouts];
}
class EditWhereaboutsEvent extends WhereaboutsEvent{
  final WhereaboutsEntity whereabouts;
  final WhereaboutsEntity newWhereabouts;
  EditWhereaboutsEvent({@required this.whereabouts,@required this.newWhereabouts});
  @override
  List<Object> get props => [whereabouts,newWhereabouts];
}
class DeleteWhereaboutsEvent extends WhereaboutsEvent{
  final WhereaboutsEntity whereabouts;
  DeleteWhereaboutsEvent({@required this.whereabouts});
  @override
  List<Object> get props => [whereabouts];
}
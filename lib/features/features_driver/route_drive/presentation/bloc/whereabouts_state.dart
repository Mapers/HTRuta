part of 'whereabouts_bloc.dart';

abstract class WhereaboutsState extends Equatable {
  const WhereaboutsState();
  
  @override
  List<Object> get props => [];
}

class LoadingWhereaboutsState extends WhereaboutsState {}
class DataWhereaboutsState extends WhereaboutsState {
  final List<WhereaboutsEntity> whereaabouts;
  DataWhereaboutsState({this.whereaabouts});
  @override
  List<Object> get props => [];
}

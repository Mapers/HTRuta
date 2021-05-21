part of 'availables_routes_bloc.dart';

abstract class AvailablesRoutesEvent extends Equatable {
  const AvailablesRoutesEvent();

  @override
  List<Object> get props => [];
}
class GetAvailablesRoutesEvent extends AvailablesRoutesEvent {
  final LocationEntity to;
  final LocationEntity from;
  final double radio;
  final int seating;
  final List<int> paymentMethods;

  const GetAvailablesRoutesEvent({@required this.to, @required this.from, @required this.radio, @required this.seating, @required this.paymentMethods});
  @override
  List<Object> get props => [to, from, radio, seating, paymentMethods];
}

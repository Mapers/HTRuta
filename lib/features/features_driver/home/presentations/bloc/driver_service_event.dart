part of 'driver_service_bloc.dart';

abstract class DriverServiceEvent extends Equatable {
  const DriverServiceEvent();

  @override
  List<Object> get props => [];
}

class ChangeDriverServiceEvent extends DriverServiceEvent {
  final TypeDriverService type;
  ChangeDriverServiceEvent({@required this.type});

  @override
  List<Object> get props => [type];
}
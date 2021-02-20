part of 'driver_service_bloc.dart';

abstract class DriverServiceState extends Equatable {
  const DriverServiceState();
  
  @override
  List<Object> get props => [];
}

class DataDriverServiceState extends DriverServiceState {
  final TypeServiceDriver typeService;
  DataDriverServiceState({@required this.typeService});

  factory DataDriverServiceState.initial(){
    return DataDriverServiceState(
      typeService: TypeServiceDriver.taxi
    );
  }

  DataDriverServiceState copyWith({TypeServiceDriver typeService}){
    return DataDriverServiceState(
      typeService: typeService ?? this.typeService
    );
  }

  @override
  List<Object> get props => [typeService];
}

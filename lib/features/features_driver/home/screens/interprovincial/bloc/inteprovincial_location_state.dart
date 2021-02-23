part of 'inteprovincial_location_bloc.dart';

abstract class InterprovincialLocationState extends Equatable {
  const InterprovincialLocationState();
  
  @override
  List<Object> get props => [];
}

class DataInteprovincialLocationState extends InterprovincialLocationState {
  final LocationEntity driver;
  final PassengerEntity passengerSelected;
  DataInteprovincialLocationState({@required this.driver, @required this.passengerSelected});

  factory DataInteprovincialLocationState.initial(){
    return DataInteprovincialLocationState(
      driver: null,
      passengerSelected: null
    );
  }

  DataInteprovincialLocationState copyWith({ LocationEntity driver, PassengerEntity passengerSelected }){
    return DataInteprovincialLocationState(
      driver: driver ?? this.driver,
      passengerSelected: passengerSelected ?? this.passengerSelected
    );
  }
  DataInteprovincialLocationState copyWithPassengerNull(){
    return DataInteprovincialLocationState(
      driver: this.driver,
      passengerSelected: null
    );
  }

  @override
  List<Object> get props => [driver, passengerSelected];
}

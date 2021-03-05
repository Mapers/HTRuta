part of 'inteprovincial_location_bloc.dart';

abstract class InterprovincialDriverLocationState extends Equatable {
  const InterprovincialDriverLocationState();
  
  @override
  List<Object> get props => [];
}

class DataInteprovincialDriverLocationState extends InterprovincialDriverLocationState {
  final String documentId;
  final LocationEntity location;
  final PassengerEntity passengerSelected;
  DataInteprovincialDriverLocationState({@required this.documentId, @required this.location, @required this.passengerSelected});

  factory DataInteprovincialDriverLocationState.initial(){
    return DataInteprovincialDriverLocationState(
      documentId: null,
      location: null,
      passengerSelected: null
    );
  }

  DataInteprovincialDriverLocationState copyWith({ String documentId, LocationEntity location, PassengerEntity passengerSelected }){
    return DataInteprovincialDriverLocationState(
      documentId: documentId ?? this.documentId,
      location: location ?? this.location,
      passengerSelected: passengerSelected ?? this.passengerSelected
    );
  }
  DataInteprovincialDriverLocationState copyWithPassengerNull(){
    return DataInteprovincialDriverLocationState(
      documentId: documentId,
      location: location,
      passengerSelected: null
    );
  }

  @override
  List<Object> get props => [location, passengerSelected, documentId];
}

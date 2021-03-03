part of 'inteprovincial_location_bloc.dart';

abstract class InterprovincialLocationState extends Equatable {
  const InterprovincialLocationState();
  
  @override
  List<Object> get props => [];
}

class DataInteprovincialLocationState extends InterprovincialLocationState {
  final String documentId;
  final LocationEntity location;
  final PassengerEntity passengerSelected;
  DataInteprovincialLocationState({@required this.documentId, @required this.location, @required this.passengerSelected});

  factory DataInteprovincialLocationState.initial(){
    return DataInteprovincialLocationState(
      documentId: null,
      location: null,
      passengerSelected: null
    );
  }

  DataInteprovincialLocationState copyWith({ String documentId, LocationEntity location, PassengerEntity passengerSelected }){
    return DataInteprovincialLocationState(
      documentId: documentId ?? this.documentId,
      location: location ?? this.location,
      passengerSelected: passengerSelected ?? this.passengerSelected
    );
  }
  DataInteprovincialLocationState copyWithPassengerNull(){
    return DataInteprovincialLocationState(
      documentId: documentId,
      location: location,
      passengerSelected: null
    );
  }

  @override
  List<Object> get props => [location, passengerSelected, documentId];
}

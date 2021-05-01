part of 'interprovincial_location_bloc.dart';

abstract class InterprovincialDriverLocationState extends Equatable {
  const InterprovincialDriverLocationState();
  
  @override
  List<Object> get props => [];
}

class DataInterprovincialDriverLocationState extends InterprovincialDriverLocationState {
  final String documentId;
  final LocationEntity location;
  final PassengerEntity passengerSelected;
  DataInterprovincialDriverLocationState({@required this.documentId, @required this.location, @required this.passengerSelected});

  factory DataInterprovincialDriverLocationState.initial(){
    return DataInterprovincialDriverLocationState(
      documentId: null,
      location: null,
      passengerSelected: null
    );
  }

  DataInterprovincialDriverLocationState copyWith({ String documentId, LocationEntity location, PassengerEntity passengerSelected }){
    return DataInterprovincialDriverLocationState(
      documentId: documentId ?? this.documentId,
      location: location ?? this.location,
      passengerSelected: passengerSelected ?? this.passengerSelected
    );
  }
  DataInterprovincialDriverLocationState copyWithPassengerNull(){
    return DataInterprovincialDriverLocationState(
      documentId: documentId,
      location: location,
      passengerSelected: null
    );
  }

  @override
  List<Object> get props => [location, passengerSelected, documentId];
}

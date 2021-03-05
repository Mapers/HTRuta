part of 'interprovincial_client_location_bloc.dart';

abstract class InterprovincialClientLocationState extends Equatable {
  const InterprovincialClientLocationState();
  
  @override
  List<Object> get props => [];
}

class DataInterprovincialClientLocationState extends InterprovincialClientLocationState {
  final String documentId;
  final LocationEntity location;
  final bool driverSelected;
  DataInterprovincialClientLocationState({@required this.documentId, @required this.location, @required this.driverSelected});

  factory DataInterprovincialClientLocationState.initial(){
    return DataInterprovincialClientLocationState(
      documentId: null,
      location: null,
      driverSelected: null
    );
  }

  DataInterprovincialClientLocationState copyWith({ String documentId, LocationEntity location, bool driverSelected }){
    return DataInterprovincialClientLocationState(
      documentId: documentId ?? this.documentId,
      location: location ?? this.location,
      driverSelected: driverSelected ?? this.driverSelected
    );
  }
  DataInterprovincialClientLocationState copyWithPassengerNull(){
    return DataInterprovincialClientLocationState(
      documentId: documentId,
      location: location,
      driverSelected: null
    );
  }

  @override
  List<Object> get props => [location, driverSelected, documentId];
}


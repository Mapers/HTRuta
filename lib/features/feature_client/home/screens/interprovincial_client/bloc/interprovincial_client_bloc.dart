import 'dart:async';

import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/qualification_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'interprovincial_client_event.dart';
part 'interprovincial_client_state.dart';

class InterprovincialClientBloc extends Bloc<InterprovincialClientEvent, InterprovincialClientState> {
  final InterprovincialClientRemoteDataSoruce interprovincialClientRemote;
  InterprovincialClientBloc({ @required this.interprovincialClientRemote }) : super(DataInterprovincialClientState.initial());
  @override
  Stream<InterprovincialClientState> mapEventToState(
    InterprovincialClientEvent event,
  ) async* {
    if(event is LoadInterprovincialClientEvent){
      print('Entre');
      await Future.delayed(Duration(seconds: 2));
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.notEstablished
      );
    }else if(event is InitialInterprovincialClientEvent){
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.notEstablished
      );
    }else if(event is SearchcInterprovincialClientEvent){
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.searchInterprovincial
      );
    }else if(event is DestinationInterprovincialClientEvent){
      List<Placemark> placemarkFrom = await placemarkFromCoordinates(event.to.latitude,event.to.longitude );
        Placemark placemark = placemarkFrom.first;
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.searchInterprovincial,
        interprovincialRoute: InterprovincialRouteInServiceEntity(
          toLocation: LocationEntity(
            latLang: LatLng(event.to.latitude, event.to.longitude ),
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea,
            districtName: placemark.locality ,
            streetName: placemark.thoroughfare
          )
        )
      );
    }else if( event is SendDataSolicitudInterprovincialClientEvent ){
      await interprovincialClientRemote.sendRequest(negotiationEntity: event.negotiationEntity);
    }else if( event is AcceptDataSolicitudInterprovincialClientEvent ){
      await interprovincialClientRemote.acceptRequest(negotiationEntity: event.negotiationEntity);
    }else if( event is RejecDataSolicitudInterprovincialClientEvent ){
      await interprovincialClientRemote.rejectRequest(negotiationEntity: event.negotiationEntity);
    }else if( event is SendQualificationInterprovincialClientEvent ){
      await interprovincialClientRemote.quialificationRequest(qualification: event.qualificationEntity);
    }
  }
}

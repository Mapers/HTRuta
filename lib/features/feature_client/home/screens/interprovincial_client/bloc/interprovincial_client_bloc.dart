import 'dart:async';

import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'interprovincial_client_event.dart';
part 'interprovincial_client_state.dart';

class InterprovincialClientBloc extends Bloc<InterprovincialClientEvent, InterprovincialClientState> {
  InterprovincialClientBloc() : super(DataInterprovincialClientState.initial());

  @override
  Stream<InterprovincialClientState> mapEventToState(
    InterprovincialClientEvent event,
  ) async* {
    if(event is LoadInterprovincialClientEvent){
      await Future.delayed(Duration(seconds: 2));
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.notEstablished
      );
    }else if(event is SearchcInterprovincialClientEvent){
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.searchInterprovincial
      );
    }
    else if(event is DestinationInterprovincialClientEvent){
      List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(event.to.latitude,event.to.longitude );
        Placemark placemark = placemarkFrom.first;
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
        status: InteprovincialClientStatus.searchInterprovincial,
        interprovincialRoute: InterprovincialRouteEntity(
          toLocation: LocationEntity(
            latLang: LatLng(placemark.position.latitude, placemark.position.latitude ),
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea,
            districtName: placemark.locality ,
            streetName: placemark.thoroughfare
          )
        )
      );
    }
  }
}

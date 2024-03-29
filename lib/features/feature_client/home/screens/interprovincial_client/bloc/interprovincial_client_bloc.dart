import 'dart:async';

import 'package:HTRuta/data/remote/interprovincial_remote_firestore.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/qualification_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'interprovincial_client_event.dart';
part 'interprovincial_client_state.dart';

class InterprovincialClientBloc
    extends Bloc<InterprovincialClientEvent, InterprovincialClientState> {
  final InterprovincialClientRemoteDataSoruce interprovincialClientRemote;
  InterprovincialDataFirestore interprovincialDataFirestore;
  final ServiceDataRemote serviceDataRemote;
  InterprovincialClientBloc(
      {@required this.interprovincialClientRemote,
      @required this.interprovincialDataFirestore,
      @required this.serviceDataRemote})
      : super(DataInterprovincialClientState.initial());
  @override
  Stream<InterprovincialClientState> mapEventToState(
    InterprovincialClientEvent event,
  ) async* {
    if (event is LoadInterprovincialClientEvent) {
      await Future.delayed(Duration(seconds: 2));
      yield DataInterprovincialClientState.initial()
          .copyWith(status: InterprovincialClientStatus.notEstablished);
    } else if (event is InitialInterprovincialClientEvent) {
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial()
          .copyWith(status: InterprovincialClientStatus.notEstablished);
    } else if (event is SearchcInterprovincialClientEvent) {
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial()
          .copyWith(status: InterprovincialClientStatus.searchInterprovincial);
    } else if (event is AvailablesInterprovincialClientEvent) {
      yield DataInterprovincialClientState();
      yield DataInterprovincialClientState.initial().copyWith(
          status: InterprovincialClientStatus.availablesInterprovincial);
    } else if (event is DestinationInterprovincialClientEvent) {
      try {
        List<Placemark> placemarkFrom = await placemarkFromCoordinates(
            event.to.latitude, event.to.longitude);
        Placemark placemark = placemarkFrom.first;
        yield DataInterprovincialClientState();
        yield DataInterprovincialClientState.initial().copyWith(
            status: InterprovincialClientStatus.searchInterprovincial,
            interprovincialRoute:
                InterprovincialRouteInServiceEntity.onlyLocation(LocationEntity(
                    latLang: LatLng(event.to.latitude, event.to.longitude),
                    regionName: placemark.administrativeArea,
                    provinceName: placemark.subAdministrativeArea,
                    districtName: placemark.locality,
                    streetName: placemark.thoroughfare)));
      } catch (_) {}
    } else if (event is SendDataSolicitudInterprovincialClientEvent) {
      print('PRUEBA EVENTO');
      await interprovincialClientRemote.sendRequest(
          negotiationEntity: event.negotiationEntity);
    } else if (event is AcceptDataSolicitudInterprovincialClientEvent) {
      DataInterprovincialClientState currentState = state;
      final onAcceptRequest = await interprovincialDataFirestore.acceptRequest(
          documentId: event.serviceDocumentId,
          request: event.interprovincialRequest,
          origin: InterprovincialDataFirestoreOrigin.client);
      await serviceDataRemote.acceptRequest(
          event.negotiationEntity.serviceId,
          event.negotiationEntity.passengerId,
          onAcceptRequest.passenger.documentId);
      yield currentState.copyWith(
          passengerDocumentId: onAcceptRequest.passenger.documentId);
    } else if (event is RejecDataSolicitudInterprovincialClientEvent) {
      await serviceDataRemote.rejectRequest(event.negotiationEntity.serviceId,
          event.negotiationEntity.passengerId);
    } else if (event is SendQualificationInterprovincialClientEvent) {
      await interprovincialClientRemote.qualificationRequest(
          qualification: event.qualificationEntity);
    }
  }
}

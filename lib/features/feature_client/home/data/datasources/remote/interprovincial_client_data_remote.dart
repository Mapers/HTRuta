import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/client_interprovicial_routes_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/comnts_driver_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/qualification_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterprovincialClientRemoteDataSoruce {
  final RequestHttp requestHttp;
  final FirebaseFirestore firestore;
  InterprovincialClientRemoteDataSoruce(
      {@required this.firestore, @required this.requestHttp});
  List<ClientInterporvincialRoutesEntity> routes = [];

  Future<List<AvailableRouteEntity>> getAvailablesRoutes(
      {@required LocationEntity from,
      @required LocationEntity to,
      @required double radio,
      @required int seating,
      @required final List<int> paymentMethods}) async {
    List<AvailableRouteEntity> availablesRoutes = [];
    //double latInicial = -6.305;
    //double lngInicial = -77.89;
    //double latFinal = -6.23;
    //double lngFinal = -77.86;
    ResponseHttp result = await requestHttp.postForm(
        //Config.nuevaRutaApi + '/interprovincial/passenger/search-routes',
        'http://207.180.246.8:3000/test_api/getubigeo',
        data: {
          'latInicio': from.latLang.latitude.toString(),
          'longInicio': from.latLang.longitude.toString(),
          'latFinal': to.latLang.latitude.toString(),
          'longFinal': to.latLang.longitude.toString(),
        }
        /* data: {
        'latInicio': latInicial.toString(),
        'longInicio': lngInicial.toString(),
        'latFinal': latFinal.toString(),
        'longFinal': lngFinal.toString(),
      } */
        );
    availablesRoutes = AvailableRouteEntity.fromListJson(result.data);
    print(availablesRoutes);
    return availablesRoutes;
  }

  Future<List<CommentsDriverEntity>> getCommentsRoutes(
      {@required AvailableRouteEntity availablesRoutesEntity}) async {
    ResponseHttp result = await requestHttp.post(
        Config.nuevaRutaApi + '/interprovincial/driver/passenger/get-comments',
        data: {'service_id': availablesRoutesEntity.id});
    List<CommentsDriverEntity> commentsDriver =
        CommentsDriverEntity.fromListJson(result.data);
    return commentsDriver;
  }

  Future<void> sendRequest(
      {@required NegotiationEntity negotiationEntity}) async {
    await requestHttp
        .post(Config.nuevaRutaApi + '/interprovincial/send-request', data: {
      'service_id': negotiationEntity.serviceId,
      'seating': negotiationEntity.seating,
      'cost': negotiationEntity.cost,
      'passenger_id': negotiationEntity.passengerId,
      'request_document_id': negotiationEntity.requestDocumentId,
      'from': negotiationEntity.from.toMap,
      'to': negotiationEntity.to.toMap,
    });
  }

  Future<void> qualificationRequest(
      {@required QualificationEntity qualification}) async {
    await requestHttp.post(
        Config.nuevaRutaApi +
            '/interprovincial/driver/service/send-qualification',
        data: {
          'service_id': qualification.serviceId,
          'passenger_id': qualification.passengerId,
          'qualifying_person': getTypeEntity(qualification.qualifying_person),
          'stars': qualification.starts,
          'comment': qualification.comment
        });
  }

  Future<void> cancelTrip({@required String serviceId}) async {
    await requestHttp.post(
        '${Config.nuevaRutaApi}/interprovincial/driver/service/finish',
        data: {'service_id': serviceId});
  }
}

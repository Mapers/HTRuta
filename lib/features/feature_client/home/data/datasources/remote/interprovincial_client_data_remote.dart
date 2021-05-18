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
  InterprovincialClientRemoteDataSoruce({@required this.firestore, @required this.requestHttp });
  List<ClientInterporvincialRoutesEntity> routes =[];

  Future<List<AvailableRouteEntity>> getAvailablesRoutes({@required LocationEntity from,@required LocationEntity to,@required double radio,@required int seating}) async{
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/passenger/search-routes',
      data: {
        'radio': radio,
        'seating': seating,
        'position_user': from.toMap,
        'to': to.toMap
      }
    );

    List<AvailableRouteEntity> availablesRoutes =  AvailableRouteEntity.fromListJson(result.data);
    return availablesRoutes;
  }

  Future<List<CommentsDriverEntity>> getCommentsRoutes({@required AvailableRouteEntity availablesRoutesEntity}) async{
    print('sigo mi caminodsdsd');
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/passenger/get-comments',
      data: {
        'service_id': availablesRoutesEntity.id
      }
    );
    print(result.data);
    List<CommentsDriverEntity> commentsDriver =  CommentsDriverEntity.fromListJson(result.data);
    return commentsDriver;
  }

  Future<void> sendCommentPassenger({@required AvailableRouteEntity availablesRoutesEntity}) async{
    await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/service/send-qualification',
      data: {
        'service_id': 2,
        'passenger_id': 1042,
        'qualifying_person': 'PASSENGER',
        'stars': 4.5,
        'comment':null
      }
    );
  }
  Future<void> sendRequest({@required NegotiationEntity negotiationEntity }) async{
    print('..................');
      print(negotiationEntity.serviceId);
      print(negotiationEntity.seating);
      print( negotiationEntity.cost);
      print(negotiationEntity.passengerId);
      print(negotiationEntity.requestDocumentId);
      print( negotiationEntity.from.toMap);
      print( negotiationEntity.to.toMap);
    print('..................');
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/send-request',
      data: {
        'service_id': negotiationEntity.serviceId,
        'seating': negotiationEntity.seating,
        'cost': negotiationEntity.cost ,
        'passenger_id': negotiationEntity.passengerId,
        'request_document_id':  negotiationEntity.requestDocumentId ,
        'from':  negotiationEntity.from.toMap ,
        'to':  negotiationEntity.to.toMap ,
      }
    );
    print('###################');
    print(result.success);
    print(result.data);
    print(result.error);
    print('###################');
  }
  Future<void> quialificationRequest({ QualificationEntity qualification}) async{
    await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/service/send-qualification',
      data: {
        {
          'service_id': qualification.service_id ,
          'passenger_id': qualification.passenger_id ,
          'qualifying_person':  getTypeEntity( qualification.qualifying_person ),
          'stars': qualification.starts ,
          'comment': qualification.comment
        }
      }
    );
  }
}
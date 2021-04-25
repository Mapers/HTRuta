import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/vehicle_seat_layout_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/client_interprovicial_routes_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/comnts_driver_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../../config.dart';

class InterprovincialClientRemoteDataSoruce {
  final RequestHttp requestHttp;
  final FirebaseFirestore firestore;
  InterprovincialClientRemoteDataSoruce({@required this.firestore, @required this.requestHttp });
  List<ClientInterporvincialRoutesEntity> routes =[];

  Future<List<AvailableRouteEntity>> getAvailablesRoutes({@required LocationEntity from,@required LocationEntity to,@required double radio,@required int seating}) async{
    print('..................');
    print(radio);
    print(seating);
    print(from.toMap);
    print(to.toMap);
    print('..................');
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/passenger/search-routes',
      data: {
        'radio': radio,
        'seating': seating,
        'position_user': from.toMap,
        'to': to.toMap
      }
    );
    print('###################');
    print(result.data);
    print('###################');
    List<AvailableRouteEntity> availablesRoutes =  AvailableRouteEntity.fromListJson(result.data);
    return availablesRoutes;
  }
  Future<List<AvailableRouteEntity>> getFiebaseAvailablesRoutes() async{
    List<AvailableRouteEntity> availablesRoutes =[];
    QuerySnapshot lisAvailableRouteFirebase =  await firestore.collection('interprovincial_in_service').get();
    for (var item in lisAvailableRouteFirebase.docs) {
      availablesRoutes.add(
        AvailableRouteEntity(
          id: 1,
          status: InterprovincialStatus.inRoute,
          documentId:item.id,
          availableSeats: item.data()['available_seats'],
          vehicleSeatLayout: VehicleSeatLayout.miniban,
          route: InterprovincialRouteInServiceEntity.test(),
          routeStartDateTime: DateTime.now(),
          fcm_token: item.data()['fcm_token']
        ),
      );
    }
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
    print(negotiationEntity.service_id);
    print(negotiationEntity.passenger_id);
    print(negotiationEntity.cost);
    print(negotiationEntity.seating);
    await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/send-request',
      data: {
        'service_id': negotiationEntity.service_id,
        'seating': negotiationEntity.seating,
        'cost': negotiationEntity.cost ,
        'passenger_id': negotiationEntity.passenger_id
      }
    );
  }
}
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/vehicle_seat_layout_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/client_interprovicial_routes_entity.dart';
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
    print('llege');
    print(from);
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/passenger/search-routes',
      data: {
        'radio': radio,
        'seating': seating,
        'position_user': from.toMap,
        'to': to.toMap
      }
    );
      print('..................');
      print(result.data);
      print('..................');

    List<AvailableRouteEntity> availablesRoutes =[];
    availablesRoutes = [
      AvailableRouteEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteInServiceEntity.test(), vehicleSeatLayout: VehicleSeatLayout.miniban, fcm_token: '-'),
      AvailableRouteEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteInServiceEntity.test(), vehicleSeatLayout: VehicleSeatLayout.miniban, fcm_token: '-'),
      AvailableRouteEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteInServiceEntity.test(), vehicleSeatLayout: VehicleSeatLayout.miniban, fcm_token: '-'),
      AvailableRouteEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteInServiceEntity.test(), vehicleSeatLayout: VehicleSeatLayout.miniban, fcm_token: '-'),
      AvailableRouteEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteInServiceEntity.test(), vehicleSeatLayout: VehicleSeatLayout.miniban, fcm_token: '-'),
    ];
    return availablesRoutes;
  }
  Future<List<AvailableRouteEntity>> getFiebaseAvailablesRoutes() async{
    List<AvailableRouteEntity> availablesRoutes =[];
    //! cambira nombre  cuado este listo el back-ent
    QuerySnapshot xd =  await firestore.collection('interprovincial_in_service').get();
    for (var item in xd.docs) {
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
}
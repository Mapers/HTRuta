import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/vehicle_seat_layout_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/client_interprovicial_routes_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterprovincialClientRemoteDataSoruce {
  final FirebaseFirestore firestore;
  InterprovincialClientRemoteDataSoruce({@required this.firestore});
  List<ClientInterporvincialRoutesEntity> routes =[];

  Future<List<AvailableRouteEntity>> getAvailablesRoutes() async{
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
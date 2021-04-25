import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/vehicle_seat_layout_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AvailableRouteEntity extends Equatable{
  final int id;
  final int availableSeats;
  final String documentId;
  final VehicleSeatLayout vehicleSeatLayout; //? se usara cuando  se habilite tipos de movilidad
  final InterprovincialStatus status;
  final InterprovincialRouteInServiceEntity route;
  final DateTime routeStartDateTime;
  final String fcm_token;


  AvailableRouteEntity( {
    @required this.id,
    @required this.availableSeats,
    @required this.documentId,
    this.vehicleSeatLayout,
    @required this.status,
    @required this.route,
    @required this.routeStartDateTime,
    @required this.fcm_token,
  });
  Map<String, dynamic> get toMap => {
    'id': id,
    'available_seats': availableSeats,
    'document_id': documentId,
    'status': status,
    'rutas': route.toMap,
    'route_start_dateTime':routeStartDateTime,
    'fcm_token':fcm_token
  };

  factory AvailableRouteEntity.fromJson(Map<String, dynamic> dataJson){
    return AvailableRouteEntity(
      id: int.parse(dataJson['id']),
      availableSeats: int.parse(dataJson['available_seats']) ,
      documentId: dataJson['document_id'],
      status: toInterprovincialStatusFromString(dataJson['status']),
      route: InterprovincialRouteInServiceEntity.fromJson(dataJson['rutas']),
      routeStartDateTime: DateTime.parse(dataJson['route_start_dateTime']),
      fcm_token: dataJson['fcm_token'],
    );
  }
  static List<AvailableRouteEntity> fromListJson(List<dynamic> listJson){
    List<AvailableRouteEntity> list = [];
    listJson.forEach((data) => list.add(AvailableRouteEntity.fromJson(data)));
    return list;
  }


  @override
  List<Object> get props => [id, availableSeats, vehicleSeatLayout, documentId, status, route, routeStartDateTime,fcm_token];
}
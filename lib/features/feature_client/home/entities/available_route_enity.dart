import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/vehicle_seat_layout_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AvailableRouteEntity extends Equatable{
  final int id;
  final int availableSeats;
  final String documentId;
  final VehicleSeatLayout vehicleSeatLayout;
  final InterprovincialStatus status;
  final InterprovincialRouteInServiceEntity route;
  final DateTime routeStartDateTime;
  final String fcm_token;

  AvailableRouteEntity( {
    @required this.id,
    @required this.availableSeats,
    @required this.documentId,
    @required this.vehicleSeatLayout,
    @required this.status,
    @required this.route,
    @required this.routeStartDateTime,
    @required this.fcm_token,
  });

  @override
  List<Object> get props => [id, availableSeats, vehicleSeatLayout, documentId, status, route, routeStartDateTime,fcm_token];
}
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AvailablesRoutesEntity extends Equatable{
  final int id;
  final int availableSeats;
  final String documentId;
  final InterprovincialStatus status;
  final InterprovincialRouteEntity route;
  final DateTime routeStartDateTime;

  AvailablesRoutesEntity({
    @required this.id,
    @required this.availableSeats,
    @required this.documentId,
    @required this.status,
    @required this.route,
    @required this.routeStartDateTime
  });

  @override
  List<Object> get props => [id, availableSeats, documentId, status, route, routeStartDateTime];
}
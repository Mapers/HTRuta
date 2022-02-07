import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/vehicle_seat_layout_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class AvailableRouteEntity extends Equatable {
  final String id;
  final int availableSeats;
  final String documentId;
  final VehicleSeatLayout
      vehicleSeatLayout; //? se usara cuando  se habilite tipos de movilidad
  final InterprovincialStatus status;
  final InterprovincialRouteInServiceEntity route;
  final DateTime routeStartDateTime;
  final String fcm_token;
  final String serviceId;

  AvailableRouteEntity({
    @required this.id,
    @required this.availableSeats,
    @required this.documentId,
    this.vehicleSeatLayout,
    @required this.status,
    @required this.route,
    @required this.routeStartDateTime,
    @required this.fcm_token,
    this.serviceId,
  });
  Map<String, dynamic> get toMap => {
        'id': id,
        'available_seats': availableSeats,
        'document_id': documentId,
        'status': status,
        'rutas': route.toMap,
        'route_start_dateTime': routeStartDateTime,
        'service_id': serviceId
      };

  factory AvailableRouteEntity.fromJson(Map<String, dynamic> dataJson) {
    return AvailableRouteEntity(
      id: dataJson['Id'].toString(),
      availableSeats: dataJson['cantidadDisponible'] ?? 0,
      documentId: dataJson['IDocumento'],
      // status: dataJson['status'],
      status: toInterprovincialStatusFromString(dataJson['estadoServicio']),
      route: InterprovincialRouteInServiceEntity(
          id: dataJson['id']?.toString(),
          name: dataJson['name'] ?? '',
          driverPhone: dataJson['phone_number'] ?? '',
          driverCellphone: dataJson['phone_number'] ?? '',
          driverImage: dataJson['url_img'] ?? '',
          driverName: dataJson['driver_name'] ?? '',
          cost: dataJson['mPrecio'].toDouble(),
          fromLocation: LocationEntity(
              districtName: dataJson['vchDistritoInicial'],
              latLang: LatLng(
                double.parse(dataJson['vchLatInicial'] ?? '0'),
                double.parse(dataJson['vchLongInicial'] ?? '0'),
              ),
              provinceName: dataJson['vchProvinciaInicial'] ?? '',
              regionName: dataJson['vchRegionInicial'] ?? '',
              streetName: dataJson['vchDireccionInicial'] ?? '',
              zoom: 6.36),
          toLocation: LocationEntity(
              districtName: dataJson['vchDistritoFinal'],
              latLang: LatLng(
                double.parse(dataJson['vchLatFinal'] ?? '0'),
                double.parse(dataJson['vchLongFinal'] ?? '0'),
              ),
              provinceName: dataJson['vchProvinciaFinal'] ?? '',
              regionName: dataJson['vchRegionFinal'] ?? '',
              streetName: dataJson['vchDireccionFinal'] ?? '',
              zoom: 6.36),
          starts: 1.00,
          whereAboutstOne:
              LocationEntity.fromJson(dataJson['whereabouts_one'] ?? {}),
          whereAboutstTwo:
              LocationEntity.fromJson(dataJson['whereabouts_two'] ?? {})),
      routeStartDateTime: DateTime.parse(dataJson['fechaInicio']),
      fcm_token: dataJson['fcm_token'] ?? '',
      serviceId: dataJson['IDocumento'],
    );
  }
  static List<AvailableRouteEntity> fromListJson(List<dynamic> listJson) {
    List<AvailableRouteEntity> list = [];
    listJson.forEach((data) => list.add(AvailableRouteEntity.fromJson(data)));
    return list;
  }

  @override
  List<Object> get props => [
        id,
        availableSeats,
        vehicleSeatLayout,
        documentId,
        status,
        route,
        routeStartDateTime,
        fcm_token
      ];
}

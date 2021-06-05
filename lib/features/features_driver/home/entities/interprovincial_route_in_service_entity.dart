import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';

class InterprovincialRouteInServiceEntity extends Equatable {
  final String id;
  final String name;
  final String driverPhone;
  final String driverCellphone;
  final String driverImage;
  final String driverName;
  final LocationEntity fromLocation;
  final LocationEntity toLocation;
  final double cost;
  final double starts;
  final DateTime dateStart;
  final InterprovincialStatus status;

  InterprovincialRouteInServiceEntity({
    @required this.id,
    @required this.name,
    @required this.driverName,
    @required this.cost,
    @required this.fromLocation,
    @required this.toLocation,
    @required this.starts,
    this.driverPhone,
    this.driverCellphone,
    this.driverImage,
    this.dateStart,
    this.status
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'driver_phone':  driverPhone,
    'driver_cellphone': driverCellphone,
    'driver_image': driverImage,
    'name_driver': driverName,
    'from': fromLocation.toMap,
    'to': toLocation.toMap,
    'cost': cost,
    'starts': starts,
    'date_start': dateStart,
  };

  factory InterprovincialRouteInServiceEntity.test(){
    return InterprovincialRouteInServiceEntity(
      id: '1',
      name: 'Huacho - Chancay - Lima',
      driverName: 'Pepe lopez Peres' ,
      cost: 50,
      fromLocation: LocationEntity(
        latLang: LatLng(-11.109722, -77.596091),
        streetName: 'Óvalo de Huacho',
        districtName: 'Huacho',
        provinceName: 'Huaura',
        regionName: 'Gobierno Regional de Lima',
        zoom: 12
      ),
      toLocation: LocationEntity(
        latLang: LatLng(-12.005404, -77.055431),
        streetName: 'Gran Terminal Plaza Norte, Independencia, Lima',
        districtName: 'Independencia',
        provinceName: 'Lima',
        regionName: 'Lima',
        zoom: 12
      ),
      starts: 3.4
    );
  }

  factory InterprovincialRouteInServiceEntity.fromRoute({@required String id, @required InterprovincialRouteEntity interprovincialRoute, @required String driverName, double starts}){
    return InterprovincialRouteInServiceEntity(
      id: id,
      name: interprovincialRoute.name,
      driverName: driverName,
      cost: interprovincialRoute.cost,
      fromLocation: interprovincialRoute.from,
      toLocation: interprovincialRoute.to,
      starts: starts
    );
  }

  factory InterprovincialRouteInServiceEntity.fromJson(Map<String, dynamic> dataJson){
   
    double starts;
    dataJson['starts'] == null ? starts = 0 : starts = double.parse(dataJson['starts']);
    return InterprovincialRouteInServiceEntity(
      id: dataJson['id'],
      name: dataJson['name'],
      driverPhone: dataJson['driver_phone'],
      driverCellphone: dataJson['driver_cellphone'],
      driverImage: dataJson['driver_image'],
      driverName: dataJson['driver_name'],
      cost: double.parse(dataJson['cost']),
      fromLocation: LocationEntity.fromJson(dataJson['from']),
      toLocation: LocationEntity.fromJson(dataJson['to']),
      starts: starts,
    );
  }
  factory InterprovincialRouteInServiceEntity.fromJsonRecovery(Map<String, dynamic> dataJson){
    double starts;
    dataJson['starts'] == null ? starts = 0 : starts = double.parse(dataJson['starts']);
    return InterprovincialRouteInServiceEntity(
      id: dataJson['id'],
      name: dataJson['name'],
      driverPhone: dataJson['driver_phone'],
      driverCellphone: dataJson['driver_cellphone'],
      driverImage: dataJson['driver_image'],
      driverName: dataJson['driver_name'],
      cost: double.parse(dataJson['cost']),
      fromLocation: LocationEntity.fromJson(dataJson['from']),
      toLocation: LocationEntity.fromJson(dataJson['to']),
      dateStart:DateTime.parse(dataJson['date_start']) ,
      status: toInterprovincialStatusFromString(dataJson['status']),
      starts: starts,
    );
  }

  factory InterprovincialRouteInServiceEntity.onlyLocation(LocationEntity toLocation){
    return InterprovincialRouteInServiceEntity(
      id: null,
      name: null,
      driverName: null,
      cost: null,
      fromLocation: null,
      toLocation: toLocation,
      dateStart: null,
      starts: null,
    );
  }

  @override
  List<Object> get props => [id, name, driverName, driverPhone, driverCellphone, driverImage, cost, fromLocation, toLocation, starts];
}
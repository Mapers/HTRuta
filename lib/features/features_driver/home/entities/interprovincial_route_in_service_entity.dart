import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class InterprovincialRouteInServiceEntity extends Equatable {
  final String id;
  final String name;
  final String nameDriver;
  final LocationEntity fromLocation;
  final LocationEntity toLocation;
  final double cost;
  final double starts;

  InterprovincialRouteInServiceEntity({
    @required this.id,
    @required this.name,
    @required this.nameDriver,
    @required this.cost,
    @required this.fromLocation,
    @required this.toLocation,
    @required this.starts,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'driver_name': nameDriver,
    'from': fromLocation.toMap,
    'to': toLocation.toMap,
    'cost': cost,
    'starts': starts,
  };

  factory InterprovincialRouteInServiceEntity.test(){
    return InterprovincialRouteInServiceEntity(
      id: '1',
      name: 'Huacho - Chancay - Lima',
      nameDriver: 'Pepe lopez Peres' ,
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
      nameDriver: driverName,
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
      nameDriver: dataJson['driver_name'],
      cost: double.parse(dataJson['cost']),
      fromLocation: LocationEntity.fromJson(dataJson['from']),
      toLocation: LocationEntity.fromJson(dataJson['to']),
      starts: starts,
    );
  }

  @override
  List<Object> get props => [id, name, nameDriver, cost, fromLocation, toLocation, starts];
}
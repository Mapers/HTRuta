import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class InterprovincialRouteEntity extends Equatable {
  final String id;
  final String name;
  final String nameDriver;
  final LocationEntity fromLocation;
  final LocationEntity toLocation;
  final double cost;
  final List<WhereaboutsEntity> whereabouts;

  InterprovincialRouteEntity({
    @required this.id,
    @required this.name,
    @required this.nameDriver,
    @required this.cost,
    @required this.fromLocation,
    @required this.toLocation,
    @required this.whereabouts,
  });

  factory InterprovincialRouteEntity.test(){
    return InterprovincialRouteEntity(
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
      whereabouts: []
    );
  }

  @override
  List<Object> get props => [id, name, nameDriver, cost, fromLocation, toLocation, whereabouts];
}
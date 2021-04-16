import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterprovincialDataRemote{
  Future<List<InterprovincialRouteInServiceEntity>> getAllRoutesByUser() async{
    return [
      InterprovincialRouteInServiceEntity(
        id: '1',
        name: 'Huacho - Chancay - Lima',
        nameDriver: 'Jose Carlos',
        starts: 4,
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
      ),
      InterprovincialRouteInServiceEntity(
        id: '2',
        cost: 60,
        starts: 3,
        nameDriver: 'Juan Perez',
        name: 'Lima - Cajamarca (Directo)',
        fromLocation: LocationEntity(
          latLang: LatLng(-12.064508, -76.996569),
          streetName: 'Manuel Echeandia, San Luis, Lima',
          districtName: 'Acho',
          provinceName: 'Lima',
          regionName: 'Lima',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-7.166157, -78.508878),
          streetName: 'Av. La Paz 361-301',
          districtName: 'Cajamarca',
          provinceName: 'Cajamarca',
          regionName: 'Cajamarca',
          zoom: 12
        ),
      ),
      InterprovincialRouteInServiceEntity(
        id: '3',
        cost: 70,
        starts: 2,
        nameDriver: 'Rodrigo Ugarte',
        name: 'Cajamarca - Chimbote - Lima',
        fromLocation: LocationEntity(
          latLang: LatLng(-7.166157, -78.508878),
          streetName: 'Av. La Paz 361-301, Cajamarca, Cajamarca',
          districtName: 'Cajamarca',
          provinceName: 'Cajamarca',
          regionName: 'Cajamarca',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-12.064508, -76.996569),
          streetName: 'Manuel Echeandia, San Luis, Lima',
          districtName: 'Acho',
          provinceName: 'Lima',
          regionName: 'Lima',
          zoom: 12
        ),
      ),
    ];
  }
}
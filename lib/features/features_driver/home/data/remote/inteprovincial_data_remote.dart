import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterprovincialDataRemote{
  Future<List<InterprovincialRouteEntity>> getAllRoutesByUser() async{
    return [
      InterprovincialRouteEntity(
        id: '1',
        name: 'Huacho - Chancay - Lima',
        fromLocation: LocationEntity(
          latLang: LatLng(-11.109722, -77.596091),
          streetName: 'Óvalo de Huacho',
          districtName: 'Huacho',
          provinceName: 'Huaura',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-12.005404, -77.055431),
          streetName: 'Gran Terminal Plaza Norte, Independencia, Lima',
          districtName: 'Independencia',
          provinceName: 'Lima',
          zoom: 12
        )
      ),
      InterprovincialRouteEntity(
        id: '2',
        name: 'Lima - Cajamarca (Directo)',
        fromLocation: LocationEntity(
          latLang: LatLng(-12.064508, -76.996569),
          streetName: 'Manuel Echeandia, San Luis, Lima',
          districtName: 'Acho',
          provinceName: 'Lima',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-7.166157, -78.508878),
          streetName: 'Av. La Paz 361-301',
          districtName: 'Cajamarca',
          provinceName: 'Cajamarca',
          zoom: 12
        )
      ),
      InterprovincialRouteEntity(
        id: '3',
        name: 'Cajamarca - Chimbote - Lima',
        fromLocation: LocationEntity(
          latLang: LatLng(-7.166157, -78.508878),
          streetName: 'Av. La Paz 361-301, Cajamarca, Cajamarca',
          districtName: 'Cajamarca',
          provinceName: 'Cajamarca',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-12.064508, -76.996569),
          streetName: 'Manuel Echeandia, San Luis, Lima',
          districtName: 'Acho',
          provinceName: 'Lima',
          zoom: 12
        )
      ),
    ];
  }
}
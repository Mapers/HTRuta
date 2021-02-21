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
          name: 'Óvalo de Huacho, Huaura, Lima',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-12.005404, -77.055431),
          name: 'Gran Terminal Plaza Norte, Independencia, Lima',
          zoom: 12
        )
      ),
      InterprovincialRouteEntity(
        id: '2',
        name: 'Lima - Cajamarca (Directo)',
        fromLocation: LocationEntity(
          latLang: LatLng(-12.064508, -76.996569),
          name: 'Manuel Echeandia, San Luis, Lima',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-7.166157, -78.508878),
          name: 'Av. La Paz 361-301, Cajamarca, Cajamarca',
          zoom: 12
        )
      ),
      InterprovincialRouteEntity(
        id: '3',
        name: 'Cajamarca - Chimbote - Lima',
        fromLocation: LocationEntity(
          latLang: LatLng(-7.166157, -78.508878),
          name: 'Av. La Paz 361-301, Cajamarca, Cajamarca',
          zoom: 12
        ),
        toLocation: LocationEntity(
          latLang: LatLng(-12.064508, -76.996569),
          name: 'Manuel Echeandia, San Luis, Lima',
          zoom: 12
        )
      ),
    ];
  }
}
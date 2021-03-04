import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class InterprovincialDataRemote{
  final FirebaseFirestore firestore;
  InterprovincialDataRemote({@required this.firestore});

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
      ),
      InterprovincialRouteEntity(
        id: '2',
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
        whereabouts: []
      ),
      InterprovincialRouteEntity(
        id: '3',
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
        whereabouts: []
      ),
    ];
  }

  Future<String> createStartService({
    @required InterprovincialStatus status,
    @required InterprovincialRouteEntity route,
    @required DateTime routeStartDateTime,
    @required int availableSeats,
  }) async{
    LocationEntity fromLocation = route.fromLocation;
    DocumentReference dr = await firestore.collection('drivers_in_service').add({
      'status': toStringFirebaseInterprovincialStatus(status),
      'current_location': GeoPoint(fromLocation.latLang.latitude, fromLocation.latLang.longitude),
      'street': fromLocation.streetName,
      'district_name': fromLocation.districtName,
      'province_name': fromLocation.provinceName,
      'region_name': fromLocation.regionName,
      'available_seats': availableSeats
    });
    return dr.id;
  }

  Future<bool> updateSeatsQuantity({
    @required String documentId,
    @required int availableSeats
  }) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId).update({
        'available_seats': availableSeats
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeToStartRouteInService({
    @required String documentId,
    @required InterprovincialStatus status
  }) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId).update({
        'status': toStringFirebaseInterprovincialStatus(status)
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateLocationInService({
    @required String documentId,
    @required LocationEntity location
  }) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId).update({
        'current_location': GeoPoint(location.latLang.latitude, location.latLang.longitude),
        'street': location.streetName,
        'district_name': location.districtName,
        'province_name': location.provinceName,
        'region_name': location.regionName,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
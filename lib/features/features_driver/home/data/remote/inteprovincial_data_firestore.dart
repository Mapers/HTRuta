import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class InterprovincialDataFirestore{
  final FirebaseFirestore firestore;
  InterprovincialDataFirestore({@required this.firestore});

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

  Stream<List<PassengerEntity>> getStreamPassengers({@required String documentId}){
    return firestore.collection('drivers_in_service').doc(documentId)
    .collection('passengers').snapshots()
    .map<List<PassengerEntity>>((querySnapshot) =>
      querySnapshot.docs.map<PassengerEntity>((doc){
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return PassengerEntity.fromJsonLocal(data);
      }).toList()
    );
  }

  Stream<List<InterprovincialRequestEntity>> getStreamRequests({@required String documentId}){
    return firestore.collection('drivers_in_service').doc(documentId)
    .collection('requests').snapshots()
    .map<List<InterprovincialRequestEntity>>((querySnapshot) =>
      querySnapshot.docs.map<InterprovincialRequestEntity>((doc){
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return InterprovincialRequestEntity.fromJsonLocal(data);
      }).toList()
    );
  }

  Future<int> removePassenger({@required String documentId, @required PassengerEntity passenger}) async{
    try {
      DocumentReference dr = firestore.collection('drivers_in_service').doc(documentId);
      List<dynamic> result = await Future.wait([
        dr.get(),
        dr.collection('passengers').doc(passenger.documentId).delete()
      ]);
      DocumentSnapshot ds = result.first;
      int newAvailableSeats = ds.data()['available_seats'] + passenger.seats;
      await dr.update({
        'available_seats': newAvailableSeats
      });
      return newAvailableSeats;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addPassenger({@required String documentId, @required PassengerEntity passenger}) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId)
      .collection('passengers').add(passenger.toFirestore);
      return true;
    } catch (e) {
      return false;
    }
  }
}
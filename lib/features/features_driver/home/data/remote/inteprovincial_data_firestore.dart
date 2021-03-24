import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

class InterprovincialDataFirestore{
  final FirebaseFirestore firestore;
  final PushMessage pushMessage;
  InterprovincialDataFirestore({@required this.firestore, @required this.pushMessage});

  Future<String> createStartService({
    @required InterprovincialStatus status,
    @required InterprovincialRouteEntity route,
    @required DateTime routeStartDateTime,
    @required int availableSeats,
  }) async{
    LocationEntity fromLocation = route.fromLocation;
    final _prefs = PreferenciaUsuario();
    DocumentReference dr = await firestore.collection('drivers_in_service').add({
      'status': toStringFirebaseInterprovincialStatus(status),
      'current_location': GeoPoint(fromLocation.latLang.latitude, fromLocation.latLang.longitude),
      'street': fromLocation.streetName,
      'district_name': fromLocation.districtName,
      'province_name': fromLocation.provinceName,
      'region_name': fromLocation.regionName,
      'available_seats': availableSeats,
      'fcm_token': _prefs.tokenPush
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

  Future<int> releaseSeatsFromPasenger({@required String documentId, @required PassengerEntity passenger}) async{
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
      Fluttertoast.showToast(msg: 'No se pudo liberar los asientos.',toastLength: Toast.LENGTH_SHORT);
      return null;
    }
  }

  Future<int> acceptRequest({@required String documentId, @required InterprovincialRequestEntity request}) async{
    try {
      DocumentReference dr = firestore.collection('drivers_in_service').doc(documentId);
      //! Esta data debe venir desde backend
      PassengerEntity passengerEntity = PassengerEntity.mock();

      List<dynamic> result = await Future.wait([
        dr.get(),
        dr.collection('passengers').add(passengerEntity.toFirestore),
        dr.collection('requests').doc(request.documentId).delete(),
      ]);

      pushMessage.sendPushMessage(
        token: request.fcmToken,
        title: 'Su solicitud ha sido aceptada por el interprovincial',
        description: 'Revise la información de interprovincial'
      );
      DocumentSnapshot ds = result.first;
      int newAvailableSeats = ds.data()['available_seats'] - request.seats;
      await dr.update({
        'available_seats': newAvailableSeats
      });
      return newAvailableSeats;
    } catch (e) {
      Fluttertoast.showToast(msg: 'No se pudo aceptar la solicitud.',toastLength: Toast.LENGTH_SHORT);
      return null;
    }
  }

  Future<bool> rejectRequest({@required String documentId, @required InterprovincialRequestEntity request}) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId)
      .collection('requests').doc(request.documentId).delete();
      pushMessage.sendPushMessage(
        token: request.fcmToken, // Token del dispositivo del chofer
        title: 'Su solicitud ha sido rechazada por el interprovincial',
        description: 'Puede realizar otra solicitud'
      );
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'No se pudo rechazar la solicitud.',toastLength: Toast.LENGTH_SHORT);
      return false;
    }
  }

  Future<bool> sendCounterOfferInRequest({@required String documentId, @required InterprovincialRequestEntity request, @required double newPrice}) async{
    try {
      DocumentReference dr = firestore.collection('drivers_in_service').doc(documentId);
      await dr.collection('requests').doc(request.documentId).update({
        'condition': getStringInterprovincialRequestCondition(InterprovincialRequestCondition.counterOffer),
        'price': newPrice
      });
      pushMessage.sendPushMessage(
        token: request.fcmToken, // Token del dispositivo del chofer
        title: 'Ha recibido una contraoferta a su solicitud de interprovincial',
        description: 'Revise la contraoferta'
      );
      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'No se pudo enviar la contraoferta.',toastLength: Toast.LENGTH_SHORT);
      return false;
    }
  }

  //! Debe ser borrado luego
  Future<bool> addRequestTest({@required String documentId, @required InterprovincialRequestEntity request}) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId)
      .collection('requests').add(request.toFirestore);
      pushMessage.sendPushMessage(
        token: request.fcmToken, // Token del dispositivo del chofer
        title: 'Ha recibido una nueva solicitud',
        description: 'Revise las solicitudes'
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
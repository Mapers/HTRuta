
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/location_drove_Entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterprovincialClientDataFirebase {
  final FirebaseFirestore firestore;
  final PushMessage pushMessage;
  InterprovincialClientDataFirebase( {@required this.firestore,@required this.pushMessage,});
  //! cambiar name del metodo
  Future<bool> addRequestTest({String documentId,InterprovincialRequestEntity request, @required String fcmTokenDriver}) async{
    try {
      await firestore.collection('drivers_in_service').doc(documentId)
      .collection('requests').add(request.toFirestore );
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
  Stream<List<InterprovincialRequestEntity>> getStreamContraoferta({@required String documentId}){
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
  Future<bool> deleteRequest({String documentId,InterprovincialRequestEntity request, @required String idRequests}) async{
    try {
      print(documentId);
      print(idRequests);
      await firestore.collection('drivers_in_service').doc(documentId)
      .collection('requests').doc(idRequests).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<LocationDriveEntity> getlocateDrive({String documentId}) async{
    LocationDriveEntity locationDrive;
    DocumentSnapshot drive =  await firestore.collection('drivers_in_service').doc(documentId).get();
    GeoPoint coordenationDrive = drive.data()['current_location'];
    locationDrive = LocationDriveEntity(
      availableSeats: drive.data()['available_seats'],
      coordenationDrive: LatLng(coordenationDrive.latitude,coordenationDrive.longitude ),
      districtName: drive.data()['district_name'],
      fcmToken: drive.data()['fcm_token'],
      provinceName: drive.data()['province_name'],
      regionName: drive.data()['region_name'],
      status: drive.data()['status'],
      street: drive.data()['street']
    );
    return locationDrive;
  }
}
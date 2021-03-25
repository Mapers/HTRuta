
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterprovincialClientDataFirebase {
  final FirebaseFirestore firestore;
  final PushMessage pushMessage;
  InterprovincialClientDataFirebase( {@required this.firestore,@required this.pushMessage,});
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
}
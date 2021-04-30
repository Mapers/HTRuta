import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/features/feature_client/home/entities/interprovincial_location_driver_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterprovincialClientDataFirebase {
  final FirebaseFirestore firestore;
  final PushMessage pushMessage;
  InterprovincialClientDataFirebase( {@required this.firestore, @required this.pushMessage,});

  Future<bool> addRequestClient({String documentId,InterprovincialRequestEntity request, @required String fcmTokenDriver,bool update}) async{
    print( fcmTokenDriver );
    try {
      await firestore.collection('interprovincial_in_service').doc(documentId)
      .collection('requests').add(request.toFirestore);
      pushMessage.sendPushMessage(
        token: 'cK4f8ltDSDSXyz_JRyoVVi:APA91bGI-F-COt-K6uVHNVN76zpDdfHjX_Tbq-Q68DI5J-26pB-FJ5L2YUupDAsLz6HrZRLmKXFSateBaeO8ggdPIOn78q_4tUSUCZAdp0Cfqts3DAbkeT66saSv8akcN3aVx_Iyfw-i', // Token del dispositivo del chofer
        title: 'Ha recibido una nueva solicitud',
        description: 'Revise las solicitudes'
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<InterprovincialRequestEntity>> getStreamContraoferta({@required String documentId}){
    return firestore.collection('interprovincial_in_service').doc(documentId)
    .collection('requests').snapshots()
    .map<List<InterprovincialRequestEntity>>((querySnapshot) =>
      querySnapshot.docs.map<InterprovincialRequestEntity>((doc){
        Map<String, dynamic> data = doc.data();
        data['document_id'] = doc.id;
        return InterprovincialRequestEntity.fromJsonLocal(data);
      }).toList()
    );
  }
  
  Future<bool> messageRequestdFirebase({String documentId,InterprovincialRequestEntity request, @required String fcmTokenDriver, bool update = false}) async{
    try {
      String message = 'Revise las solicitudes';
      if(update){
        await firestore.collection('interprovincial_in_service').doc(documentId)
        .collection('requests').doc(request.documentId).update(
          {
            'condition': getStringInterprovincialRequestCondition(InterprovincialRequestCondition.accepted)
          }
        );
        message = 'El cliente acepto la oferta';
      }else{
        await firestore.collection('interprovincial_in_service').doc(documentId)
        .collection('requests').doc(request.documentId).delete();
        message = 'Solicitud rechazada';
      }
      pushMessage.sendPushMessage(
        token: fcmTokenDriver, // Token del dispositivo del chofer
        title: message,
        description: 'Revise las solicitudes'
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<InterprovincialLocationDriverEntity> streamInterprovincialLocationDriver({@required String documentId}){
    return firestore.collection('interprovincial_in_service').doc(documentId).snapshots().map((documentSnapshot){
      dynamic dataJson = documentSnapshot.data();
      return InterprovincialLocationDriverEntity.fromJson(dataJson);
    });
  }

  Future<bool> checkIfInterprovincialLocationDriverEntityOnService({@required String documentId}) async{
    DocumentSnapshot ds = await firestore.collection('interprovincial_in_service').doc(documentId).get();
    return ds.exists;
  }
}
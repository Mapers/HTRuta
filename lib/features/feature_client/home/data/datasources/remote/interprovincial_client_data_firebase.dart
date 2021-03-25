
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
      print(documentId);
      print('...');
      print(request.fcmToken);

      await firestore.collection('drivers_in_service').doc(documentId)
      .collection('requests').add(request.toFirestore );
    pushMessage.sendPushMessage(
      token: fcmTokenDriver, // Token del dispositivo del chofer
      title: 'Ha recibido una nueva solicitud',
      description: 'Revise las solicitudes'
    );
      return true;
    } catch (e) {
      return false;
    }
  }
}
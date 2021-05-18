import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/interprovincial_location_driver_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class InterprovincialClientDataFirebase {
  final FirebaseFirestore firestore;
  final PushMessage pushMessage;
  InterprovincialClientDataFirebase( {@required this.firestore, @required this.pushMessage,});

  Future<String> addRequestClient({String documentId, InterprovincialRequestEntity request, bool update}) async{
    try {
      DocumentReference dr = await firestore.collection('interprovincial_in_service').doc(documentId);
      DocumentReference dRequests = await dr.collection('requests').add(request.toFirestore);
      DocumentSnapshot ds = await dr.get();
      InterprovincialLocationDriverEntity interprovincialLocationDriver = InterprovincialLocationDriverEntity.fromJson(ds.data());
      pushMessage.sendPushMessage(
        token: interprovincialLocationDriver.fcmToken , // Token del dispositivo del chofer
        title: 'Ha recibido una nueva solicitud',
        description: 'Revise las solicitudes'
      );
      return dRequests.id;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<List<InterprovincialRequestEntity>> getStreamContraoferta({@required String documentId}){
    return firestore.collection('interprovincial_in_service').doc(documentId)
    .collection('requests').snapshots()
    .map<List<InterprovincialRequestEntity>>((querySnapshot) =>
      querySnapshot.docs.map<InterprovincialRequestEntity>((doc){
        final data = doc.data();
        data['document_id'] = doc.id;
        return InterprovincialRequestEntity.fromJsonLocal(data);
      }).toList()
    );
  }
  
  Future<String> deleteRequest({String documentId, InterprovincialRequestEntity request, bool notificationLaunch = true}) async{
    try {
      DocumentReference dr = await firestore.collection('interprovincial_in_service').doc(documentId);
      DocumentReference dRequest = await dr.collection('requests').doc(request.documentId);
      dRequest.delete();
      DocumentSnapshot  ds = await dr.get();
      DocumentSnapshot  dsRequest = await dr.get();
      InterprovincialLocationDriverEntity interprovincialLocationDriver = InterprovincialLocationDriverEntity.fromJson(ds.data());
      if(notificationLaunch){
        pushMessage.sendPushMessage(
          token: interprovincialLocationDriver.fcmToken , // Token del dispositivo del chofer
          title: 'Solicitud rechazada',
          description: 'Revise las solicitudes'
        );
      }
      return dsRequest.data()['passenger_document_id'];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<InterprovincialLocationDriverEntity> streamInterprovincialLocationDriver({@required String documentId}) {
    return firestore.collection('interprovincial_in_service').doc(documentId).snapshots().map((documentSnapshot){
      dynamic dataJson = documentSnapshot.data();
      return InterprovincialLocationDriverEntity.fromJson(dataJson);
    });
  }

  Future<bool> checkIfInterprovincialLocationDriverEntityOnService({@required String documentId}) async{
    DocumentSnapshot ds = await firestore.collection('interprovincial_in_service').doc(documentId).get();
    return ds.exists;
  }
  Future<bool> updateCurrentPosition({@required String documentId,@required LocationEntity passengerPosition, @required String passengerDocumentId, @required double distanceInMeters}) async{
    firestore.collection('interprovincial_in_service').doc(documentId).collection('passengers').doc(passengerDocumentId).update({
      'current_location': GeoPoint(passengerPosition.latLang.latitude, passengerPosition.latLang.longitude),
      'current_street_name': passengerPosition.streetName,
      'current_district_name': passengerPosition.districtName,
      'current_province_name': passengerPosition.provinceName,
      'current_region_name': passengerPosition.regionName,
      'distance_in_meters': distanceInMeters
    }
    );
    DocumentSnapshot ds = await firestore.collection('interprovincial_in_service').doc(documentId).get();
    return ds.exists;
  }

  Future<DataNecessaryRetrieve> getDataNecessaryRetrieve({@required String documentId, @required String passengerDocumentId }) async{
    DocumentSnapshot dsp = await firestore.collection('interprovincial_in_service').doc(documentId).collection('passengers').doc(passengerDocumentId).get();
    DocumentSnapshot dss = await firestore.collection('interprovincial_in_service').doc(documentId).get();
    DataNecessaryRetrieve dataNecessaryRetrieve = DataNecessaryRetrieve(negotiatedPrice: dsp.data()['price'] , serviceId: dss.data()['servicio_id']);
    return dataNecessaryRetrieve;
  }
}
class DataNecessaryRetrieve extends Equatable {
  final String negotiatedPrice;
  final String serviceId;

  DataNecessaryRetrieve({
    @required this.negotiatedPrice,
    @required this.serviceId,
  });
  @override
  List<Object> get props => [];
}

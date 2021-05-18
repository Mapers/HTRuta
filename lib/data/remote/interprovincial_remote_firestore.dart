import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/entities/on_request_accepted_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/interprovincial_location_driver_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

class InterprovincialDataFirestore{
  final FirebaseFirestore firestore;
  final PushMessage pushMessage;
  final ServiceDataRemote serviceDataRemote;
  InterprovincialDataFirestore({@required this.firestore, @required this.pushMessage, @required this.serviceDataRemote});

  Future<OnRequestAcceptedEntity> acceptRequest({@required String documentId, @required InterprovincialRequestEntity request, @required InterprovincialDataFirestoreOrigin origin}) async{
    try {
      DocumentReference refService = firestore.collection('interprovincial_in_service').doc(documentId);

      DocumentSnapshot snapshotService = await refService.get();
      InterprovincialLocationDriverEntity interprovincialLocationDriver = InterprovincialLocationDriverEntity.fromJson(snapshotService.data());

      PassengerEntity passenger = await serviceDataRemote.getPassengerById(interprovincialLocationDriver.serviceId, request.passengerId, request.passengerFcmToken);
      passenger = passenger.copyWith(price: request.price, status: PassengerStatus.actived, seats: request.seats);

      DocumentReference drPassenger = await refService.collection('passengers').add(passenger.toFirestore);
      passenger = passenger.copyWith(documentId: drPassenger.id);

      await refService.collection('requests').doc(request.documentId).update({
        'passenger_document_id': passenger.documentId,
        'condition': getStringInterprovincialRequestCondition(InterprovincialRequestCondition.accepted),
      });

      if(origin == InterprovincialDataFirestoreOrigin.client){
        pushMessage.sendPushMessage(
          token: interprovincialLocationDriver.fcmToken,
          title: 'La contraoferta ha sido aceptada',
          description: 'Revise su lista de pasajeros'
        );
      }else{
        pushMessage.sendPushMessage(
          token: request.passengerFcmToken,
          title: 'Su solicitud ha sido aceptada por el interprovincial',
          description: 'Revise la información de interprovincial'
        );
      }

      int newAvailableSeats = interprovincialLocationDriver.availableSeats - request.seats;
      await refService.update({
        'available_seats': newAvailableSeats
      });
      return OnRequestAcceptedEntity(
        availableSeats: newAvailableSeats,
        passenger: passenger,
        price: request.price
      );
    } catch (_) {
      Fluttertoast.showToast(msg: 'No se pudo aceptar la solicitud.', toastLength: Toast.LENGTH_SHORT);
      return null;
    }
  }

  Future<bool> deletePassenger({@required String documentId, @required String passengerId}) async{
    print('###################');
    print(documentId);
    print(passengerId);
    print('###################');
    try {
      await firestore.collection('interprovincial_in_service').doc(documentId).collection('passengers').doc(passengerId).delete();
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'No se pudo realizar esta acción.',toastLength: Toast.LENGTH_SHORT);
      return false;
    }
  }

  Future<bool> rejectRequest({@required String documentId, @required InterprovincialRequestEntity request, @required String driverFcmToken, @required InterprovincialDataFirestoreOrigin origin}) async{
    try {
      await firestore.collection('interprovincial_in_service').doc(documentId)
      .collection('requests').doc(request.documentId).update({
        'condition': getStringInterprovincialRequestCondition(InterprovincialRequestCondition.rejected),
      });
      if(origin == InterprovincialDataFirestoreOrigin.driver){
        pushMessage.sendPushMessage(
          token: request.passengerFcmToken,
          title: 'Su solicitud ha sido rechazada',
          description: 'Puede realizar otra solicitud'
        );
      }else{
        pushMessage.sendPushMessage(
          token: driverFcmToken,
          title: 'La contraoferta ha sido rechazada',
          description: 'Se ha removido de la lista de solicitudes'
        );
      }
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'No se pudo rechazar la solicitud.',toastLength: Toast.LENGTH_SHORT);
      return false;
    }
  }
}

enum InterprovincialDataFirestoreOrigin {
  client, driver
}
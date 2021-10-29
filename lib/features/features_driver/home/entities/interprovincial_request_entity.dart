import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class InterprovincialRequestEntity extends Equatable {
  final String documentId;
  final String passengerId;
  final String fullNames;
  final String from;
  final String to;
  final int seats;
  final double price;
  final InterprovincialRequestCondition condition;
  final GeoPoint pointMeeting;
  final String passengerFcmToken;

  InterprovincialRequestEntity({
    @required this.documentId,
    @required this.passengerId,
    @required this.fullNames,
    @required this.price,
    @required this.seats,
    @required this.from,
    @required this.to,
    @required this.condition,
    @required this.passengerFcmToken,
    @required this.pointMeeting,
  });

  factory InterprovincialRequestEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return InterprovincialRequestEntity(
      documentId: dataJson['document_id'],
      passengerId: dataJson['passenger_id'].toString(),
      fullNames: dataJson['full_names'],
      seats: (dataJson['seats'] as num).toInt(),
      price: (dataJson['price'] as num).toDouble(),
      from: dataJson['from'],
      to: dataJson['to'],
      condition: getInterprovincialRequestConditionFromString(dataJson['condition']),
      passengerFcmToken: dataJson['passenger_fcm_token'],
      pointMeeting: dataJson['pointMeeting']
    );
  }

  Map<String, dynamic> get toFirestore => {
    'full_names': fullNames,
    'seats': seats,
    'from': from,
    'to': to,
    'passenger_id': passengerId,
    'price': price,
    'condition': getStringInterprovincialRequestCondition(condition),
    'passenger_fcm_token': passengerFcmToken,
    'pointMeeting': pointMeeting
  };

  factory InterprovincialRequestEntity.mock(){
    return InterprovincialRequestEntity(
      documentId: 's56sadf67sdf56as76df5a67sd',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      from: 'Huacho - Huaura - Huacho',
      to: 'Independencia - Lima - Lima',
      passengerId: '1',
      seats: 12,
      price: 55.99,
      condition: InterprovincialRequestCondition.offer,
      passengerFcmToken: 'dr3TmNBFSxixWmx5vc2p_Z:APA91bFTY9z3Bp442nsWKlaeaeKaq4TsjKc6XlnBUeqWrUnNY7ZvTazP4Fx3Jvj5MRsdkZiMoE7a3dJKv-yYq_9hx6_8qmT8ryWB0kJ5FnRAzjdKPDHp93ysfkqOcQ4SuCp98m14aiiL',
      // pointMeeting: pointMeeting
    );
  }

  InterprovincialRequestEntity copyWith({String fullNames, String from, String to, int seats, int passengerId, double price, InterprovincialRequestCondition condition, String passengerFcmToken,GeoPoint pointMeeting}){
    return InterprovincialRequestEntity(
      documentId: documentId,
      passengerId: passengerId ?? this.passengerId,
      fullNames: fullNames ?? this.fullNames,
      price: price ?? this.price,
      seats: seats ?? this.seats,
      from: from ?? this.from,
      to: to ?? this.to,
      condition: condition ?? this.condition,
      passengerFcmToken: passengerFcmToken ?? this.passengerFcmToken,
      pointMeeting: pointMeeting ?? this.pointMeeting
    );
  }

  @override
  List<Object> get props => [documentId, fullNames, from, to, seats, price, condition, passengerFcmToken, passengerId];
}

enum InterprovincialRequestCondition { offer, counterOffer , accepted, rejected}

String getStringInterprovincialRequestCondition(InterprovincialRequestCondition condition){
  switch (condition) {
    case InterprovincialRequestCondition.offer:
      return 'OFFER';
    case InterprovincialRequestCondition.counterOffer:
      return 'COUNTER_OFFER';
    case InterprovincialRequestCondition.accepted:
      return 'ACCEPTED';
    case InterprovincialRequestCondition.rejected:
      return 'REJECTED';
    default:
      return null;
  }
}

InterprovincialRequestCondition getInterprovincialRequestConditionFromString(String condition){
  switch (condition) {
    case 'OFFER':
      return InterprovincialRequestCondition.offer;
    case 'COUNTER_OFFER':
      return InterprovincialRequestCondition.counterOffer;
    case 'ACCEPTED':
      return InterprovincialRequestCondition.accepted;
    case 'REJECTED':
      return InterprovincialRequestCondition.rejected;
    default:
      return null;
  }
}
import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:meta/meta.dart';

class InterprovincialRequestEntity extends Equatable {
  final String documentId;
  final String fullNames;
  final String from;
  final String to;
  final int seats;
  final double price;
  final InterprovincialRequestCondition condition;
  final String fcmToken;

  InterprovincialRequestEntity({
    @required this.documentId,
    @required this.fullNames,
    @required this.price,
    @required this.seats,
    @required this.from,
    @required this.to,
    @required this.condition,
    @required this.fcmToken,
  });

  factory InterprovincialRequestEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return InterprovincialRequestEntity(
      documentId: dataJson['id'],
      fullNames: dataJson['full_names'],
      seats: (dataJson['seats'] as num).toInt(),
      price: (dataJson['price'] as num).toDouble(),
      from: dataJson['from'],
      to: dataJson['to'],
      condition: getInterprovincialRequestConditionFromString(dataJson['condition']),
      fcmToken: dataJson['fcm_token']
    );
  }

  Map<String, dynamic> get toFirestore => {
    'full_names': fullNames,
    'seats': seats,
    'from': from,
    'to': to,
    'price': price,
    'condition': getStringInterprovincialRequestCondition(condition),
    'fcm_token': fcmToken
  };

  factory InterprovincialRequestEntity.mock(){
    return InterprovincialRequestEntity(
      documentId: 's56sadf67sdf56as76df5a67sd',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      from: 'Huacho - Huaura - Huacho',
      to: 'Independencia - Lima - Lima',
      seats: 12,
      price: 55.99,
      condition: InterprovincialRequestCondition.offer,
      fcmToken: 'dr3TmNBFSxixWmx5vc2p_Z:APA91bFTY9z3Bp442nsWKlaeaeKaq4TsjKc6XlnBUeqWrUnNY7ZvTazP4Fx3Jvj5MRsdkZiMoE7a3dJKv-yYq_9hx6_8qmT8ryWB0kJ5FnRAzjdKPDHp93ysfkqOcQ4SuCp98m14aiiL'
    );
  }

  InterprovincialRequestEntity copyWith({String fullNames, String from, String to, int seats, double price, InterprovincialRequestCondition condition, String fcmToken}){
    return InterprovincialRequestEntity(
      documentId: documentId,
      fullNames: fullNames ?? this.fullNames,
      price: price ?? this.price,
      seats: seats ?? this.seats,
      from: from ?? this.from,
      to: to ?? this.to,
      condition: condition ?? this.condition,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object> get props => [documentId, fullNames, from, to, seats, price, condition, fcmToken];
}

enum InterprovincialRequestCondition { offer, counterOffer , accepted,}

String getStringInterprovincialRequestCondition(InterprovincialRequestCondition condition){
  switch (condition) {
    case InterprovincialRequestCondition.offer:
      return 'OFFER';
    case InterprovincialRequestCondition.counterOffer:
      return 'COUNTER_OFFER';
    case InterprovincialRequestCondition.accepted:
      return 'ACCEPTED';
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
    default:
      return null;
  }
}
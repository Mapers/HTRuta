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

  InterprovincialRequestEntity({
    @required this.documentId,
    @required this.fullNames,
    @required this.price,
    @required this.seats,
    @required this.from,
    @required this.to,
    @required this.condition,
  });

  factory InterprovincialRequestEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return InterprovincialRequestEntity(
      documentId: dataJson['id'],
      fullNames: dataJson['full_names'],
      seats: (dataJson['seats'] as num).toInt(),
      price: (dataJson['price'] as num).toDouble(),
      from: dataJson['from'],
      to: dataJson['to'],
      condition: getInterprovincialRequestConditionFromString(dataJson['condition'])
    );
  }

  Map<String, dynamic> get toFirestore => {
    'full_names': fullNames,
    'seats': seats,
    'from': from,
    'to': to,
    'price': price,
    'condition': getStringInterprovincialRequestCondition(condition)
  };

  factory InterprovincialRequestEntity.mock(){
    return InterprovincialRequestEntity(
      documentId: 's56sadf67sdf56as76df5a67sd',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      from: 'Huacho - Huaura - Huacho',
      to: 'Independencia - Lima - Lima',
      seats: 12,
      price: 55.99,
      condition: InterprovincialRequestCondition.offer
    );
  }

  InterprovincialRequestEntity copyWith({String fullNames, String from, String to, int seats, double price, InterprovincialRequestCondition condition}){
    return InterprovincialRequestEntity(
      documentId: documentId,
      fullNames: fullNames ?? this.fullNames,
      price: price ?? this.price,
      seats: seats ?? this.seats,
      from: from ?? this.from,
      to: to ?? this.to,
      condition: condition ?? this.condition,
    );
  }

  @override
  List<Object> get props => [documentId, fullNames, from, to, seats, price, condition];
}

enum InterprovincialRequestCondition { offer, counterOffer }

String getStringInterprovincialRequestCondition(InterprovincialRequestCondition condition){
  switch (condition) {
    case InterprovincialRequestCondition.offer:
      return 'OFFER';
    case InterprovincialRequestCondition.counterOffer:
      return 'COUNTER_OFFER';
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
    default:
      return null;
  }
}
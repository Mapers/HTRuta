import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:meta/meta.dart';

class InterprovincialRequestEntity extends Equatable {
  final String documentId;
  final String fullNames;
  final String from;
  final String to;
  final int seats;
  final double price;

  InterprovincialRequestEntity({
    @required this.documentId,
    @required this.fullNames,
    @required this.price,
    @required this.seats,
    @required this.from,
    @required this.to,
  });

  factory InterprovincialRequestEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return InterprovincialRequestEntity(
      documentId: dataJson['id'],
      fullNames: dataJson['full_names'],
      seats: (dataJson['seats'] as num).toInt(),
      price: (dataJson['price'] as num).toDouble(),
      from: dataJson['from'],
      to: dataJson['to'],
    );
  }

  factory InterprovincialRequestEntity.mock(){
    return InterprovincialRequestEntity(
      documentId: 's56sadf67sdf56as76df5a67sd',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      from: 'Huacho - Huaura - Huacho',
      to: 'Independencia - Lima - Lima',
      seats: 12,
      price: 55.99
    );
  }

  @override
  List<Object> get props => [documentId, fullNames, from, to, seats, price];
}
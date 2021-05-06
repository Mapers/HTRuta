import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NegotiationEntity extends Equatable{
  final String serviceId;
  final int seating;
  final double cost;
  final String passengerId;
  final String requestDocumentId;

  NegotiationEntity( {
    @required this.serviceId,
    this.seating,
    this.cost,
    @required this.passengerId ,
    @required this.requestDocumentId,
  });

  Map<String, dynamic> get toMap => {
    'service_id': serviceId,
    'seating': seating,
    'cost': cost,
    'passenger_id': passengerId,
    'request_document_id': requestDocumentId,
  };

  @override
  List<Object> get props => [serviceId, seating, cost, passengerId, ];
}
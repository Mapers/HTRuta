import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NegotiationEntity extends Equatable{
  final String serviceId;
  final int seating;
  final double cost;
  final String passengerId;
  final String requestDocumentId;
  final LocationEntity from;
  final LocationEntity to;

  NegotiationEntity( {
    @required this.serviceId,
    this.seating,
    this.cost,
    @required this.passengerId ,
    @required this.requestDocumentId,
    this.from,
    this.to
  });

  Map<String, dynamic> get toMap => {
    'service_id': serviceId,
    'seating': seating,
    'cost': cost,
    'passenger_id': passengerId,
    'request_document_id': requestDocumentId,
    'from': from,
    'to': to,
  };

  @override
  List<Object> get props => [serviceId, seating, cost, passengerId,from, to ];
}
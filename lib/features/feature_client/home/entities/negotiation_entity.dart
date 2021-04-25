import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NegotiationEntity extends Equatable{
  final int service_id;
  final int seating;
  final double cost;
  final int passenger_id;

  NegotiationEntity( {
    @required this.service_id,
    @required this.seating,
    @required this.cost,
    @required this.passenger_id,
  });

  Map<String, dynamic> get toMap => {
    'service_id': service_id,
    'seating': seating,
    'cost': cost,
    'passenger_id': passenger_id,
  };

  @override
  List<Object> get props => [service_id, seating, cost, passenger_id ];
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';

class QualificationEntity extends Equatable{
  final int service_id;
  final int comment;
  final TypeEntityEnum qualifying_person;
  final double starts;
  final int passenger_id;

  QualificationEntity( {
    @required this.service_id,
    this.comment,
    this.qualifying_person,
    this.starts,
    @required this.passenger_id,
  });

  Map<String, dynamic> get toMap => {
    'service_id': service_id,
    'seating': comment,
    'cost': starts,
    'passenger_id': passenger_id,
  };

  @override
  List<Object> get props => [service_id, starts, comment, qualifying_person, passenger_id ];
}
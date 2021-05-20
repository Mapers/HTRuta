import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';

class QualificationEntity extends Equatable{
  final String serviceId;
  final String comment;
  final TypeEntityEnum qualifying_person;
  final double starts;
  final String passengerId;

  QualificationEntity( {
    @required this.serviceId,
    this.comment,
    this.qualifying_person,
    this.starts,
    @required this.passengerId,
  });

  Map<String, dynamic> get toMap => {
    'service_id': serviceId,
    'seating': comment,
    'cost': starts,
    'passenger_id': passengerId,
  };

  @override
  List<Object> get props => [serviceId, starts, comment, qualifying_person, passengerId ];
}
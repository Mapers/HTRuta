import 'package:equatable/equatable.dart';
class AvailablesRoutesEntity extends Equatable{
  final int id;
  final String origin;
  final String destination;
  final String costo;
  final bool state;
  final String street;
  final String nameDriver;
  final String time;
  final String date;


  AvailablesRoutesEntity({
    this.origin,
    this.destination,
    this.costo,
    this.state,
    this.street,
    this.nameDriver,
    this.time,
    this.date,
    this.id,
  });

  @override
  List<Object> get props => [origin, destination, costo, state, street, nameDriver, time, date, id
];
}
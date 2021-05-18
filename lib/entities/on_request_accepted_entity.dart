import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OnRequestAcceptedEntity extends Equatable{
  final PassengerEntity passenger;
  final int availableSeats;
  final double price;

  OnRequestAcceptedEntity({
    @required this.passenger,
    @required this.availableSeats,
    @required this.price
  });

  @override
  List<Object> get props => [availableSeats, passenger, price];
}
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OnAcceptRequestEntity extends Equatable{
  final PassengerEntity passenger;
  final int availableSeats;

  OnAcceptRequestEntity({
    @required this.passenger,
    @required this.availableSeats
  });

  @override
  List<Object> get props => [availableSeats, passenger];
}
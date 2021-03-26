import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class InterprovincialLocationDriverEntity extends Equatable{
  final String fcmToken;
  final String status;
  final int availableSeats;
  final LocationEntity location;

  InterprovincialLocationDriverEntity({
    @required this.fcmToken,
    @required this.status,
    @required this.availableSeats,
    @required this.location,
  });

  @override
  List<Object> get props => [ fcmToken, status, availableSeats, location ];
}
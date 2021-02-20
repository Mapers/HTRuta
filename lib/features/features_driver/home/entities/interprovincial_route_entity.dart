import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:meta/meta.dart';

class InterprovincialRouteEntity extends Equatable {
  final String name;
  final LocationEntity fromLocation;
  final LocationEntity toLocation;

  InterprovincialRouteEntity({
    @required this.name,
    @required this.fromLocation,
    @required this.toLocation,
  });

  @override
  List<Object> get props => [name, fromLocation, toLocation];
}
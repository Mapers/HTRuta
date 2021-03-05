import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:meta/meta.dart';

class InterprovincialRouteEntity extends Equatable {
  final String id;
  final String name;
  final LocationEntity fromLocation;
  final LocationEntity toLocation;
  final List<LocationEntity> whereabouts;

  InterprovincialRouteEntity({
    @required this.id,
    @required this.name,
    @required this.fromLocation,
    @required this.toLocation,
    @required this.whereabouts,
  });

  @override
  List<Object> get props => [id, name, fromLocation, toLocation, whereabouts];
}
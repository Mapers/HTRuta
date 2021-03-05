import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final LocationEntity whereaboutsFrom;
  final LocationEntity whereaboutsTo;



  RouteEntity( {
    this.id,
    this.name,
    this.whereaboutsFrom,
    this.whereaboutsTo,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'whereaboutsFrom': whereaboutsFrom,
    'whereaboutsTo': whereaboutsTo,
  };

  factory RouteEntity.fromJson(
    Map<String, dynamic> dataJson
  ){
    return RouteEntity(
      id: dataJson['id'],
      name: dataJson['name'],
      whereaboutsFrom: dataJson['whereaboutsFrom'],
      whereaboutsTo: dataJson['whereaboutsTo'],
    );
  }
  factory RouteEntity.empty({@required int orderBranch}) {
    return RouteEntity(
      id: '',
      name: '',
      whereaboutsFrom: null,
      whereaboutsTo: null,
    );
  }

  @override
  List<Object> get props => [id,name,whereaboutsFrom,whereaboutsTo];
}

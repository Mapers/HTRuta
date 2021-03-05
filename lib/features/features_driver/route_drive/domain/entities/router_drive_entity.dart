import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String nameFrom;
  final String nameTo;
  final LocationEntity whereaboutsFrom;
  final LocationEntity whereaboutsTo;



  RouteEntity( {
    this.id,
    this.name,
    this.nameFrom ,
    this.nameTo,
    this.whereaboutsFrom,
    this.whereaboutsTo,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'nameFrom': nameFrom,
    'nameTo': nameTo,
    'whereaboutsFrom': whereaboutsFrom,
    'whereaboutsTo': whereaboutsTo,
  };

  factory RouteEntity.fromJson(
    Map<String, dynamic> dataJson
  ){
    return RouteEntity(
      id: dataJson['id'],
      name: dataJson['name'],
      nameFrom: dataJson['nameFrom'],
      nameTo: dataJson['nameTo'],
      whereaboutsFrom: dataJson['whereaboutsFrom'],
      whereaboutsTo: dataJson['whereaboutsTo'],
    );
  }
  factory RouteEntity.empty({@required int orderBranch}) {
    return RouteEntity(
      id: '',
      name: '',
      nameFrom: '',
      nameTo: '',
      whereaboutsFrom: null,
      whereaboutsTo: null,
    );
  }

  @override
  List<Object> get props => [id,name, nameFrom, nameTo,whereaboutsFrom,whereaboutsTo];
}

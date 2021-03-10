import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String cost;
  final LocationEntity from;
  final LocationEntity to;
  // final List<WhereaboutsEntity> whereabouts;



  RouteEntity({
    this.id,
    this.name,
    this.from,
    this.to,
    // this.whereabouts,
    this.cost,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'from': from,
    'to': to,
    // 'whereabouts': whereabouts,
    'cost': cost,

  };

  factory RouteEntity.fromJson(
    Map<String, dynamic> dataJson
  ){
    return RouteEntity(
      id: dataJson['id'],
      name: dataJson['name'],
      from: dataJson['from'],
      to: dataJson['to'],
      // whereabouts: dataJson['whereabouts'],
      cost: dataJson['cost'],
    );
  }
  factory RouteEntity.empty({@required int orderBranch}) {
    return RouteEntity(
      id: '',
      name: '',
      from: null,
      to: null,
      // whereabouts: null,
      cost: null,
    );
  }

  @override
  List<Object> get props => [ id, name, from, to,
  // whereabouts,
  cost];
}

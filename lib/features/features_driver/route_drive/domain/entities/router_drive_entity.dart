import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RouteEntity extends Equatable {
  final int id;
  final String name;
  final double cost;
  final LocationEntity from;
  final LocationEntity to;

  RouteEntity({
    this.id,
    this.name,
    this.from,
    this.to,
    this.cost,
  });

  Map<String, dynamic> get toMap =>
  {
    'id': id,
    'name': name,
    'from': from.toMap,
    'to': to.toMap,
    'cost': cost,
  };

  factory RouteEntity.fromJson(Map<String, dynamic> dataJson){
    return RouteEntity(
      id: int.parse(dataJson['id']) ,
      name: dataJson['name'],
      from: LocationEntity.fromJson(dataJson['from']),
      to: LocationEntity.fromJson(dataJson['to']),
      cost: double.parse(dataJson['cost']),
    );
  }

  factory RouteEntity.empty({@required int orderBranch}) {
    return RouteEntity(
      id: 0,
      name: '',
      from: null,
      to: null,
      cost: null,
    );
  }
  static List<RouteEntity> fromListJson(List<dynamic> listJson){
    List<RouteEntity> list = [];
    listJson.forEach((data) {
      list.add(RouteEntity.fromJson(data));
    });
    return list;
  }

  @override
  List<Object> get props => [ id, name, from, to, cost];
}

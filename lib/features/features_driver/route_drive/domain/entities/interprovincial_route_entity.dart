import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class InterprovincialRouteEntity extends Equatable {
  final int id;
  final String name;
  final double cost;
  final LocationEntity from;
  final LocationEntity to;

  InterprovincialRouteEntity({
    @required this.id,
    @required this.name,
    @required this.from,
    @required this.to,
    @required this.cost,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'from': from.toMap,
    'to': to.toMap,
    'cost': cost,
  };

  factory InterprovincialRouteEntity.fromJson(Map<String, dynamic> dataJson){
    return InterprovincialRouteEntity(
      id: int.parse(dataJson['id']) ,
      name: dataJson['name'],
      from: LocationEntity.fromJson(dataJson['from']),
      to: LocationEntity.fromJson(dataJson['to']),
      cost: double.parse(dataJson['cost']),
    );
  }

  factory InterprovincialRouteEntity.empty({@required int orderBranch}) {
    return InterprovincialRouteEntity(
      id: 0,
      name: '',
      from: null,
      to: null,
      cost: null,
    );
  }
  static List<InterprovincialRouteEntity> fromListJson(List<dynamic> listJson){
    List<InterprovincialRouteEntity> list = [];
    listJson.forEach((data) => list.add(InterprovincialRouteEntity.fromJson(data)));
    return list;
  }

  @override
  List<Object> get props => [ id, name, from, to, cost];
}

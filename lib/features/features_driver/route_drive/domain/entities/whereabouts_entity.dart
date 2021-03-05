import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class WhereaboutsEntity extends Equatable {
  final String id;
  final String cost;
  final LocationEntity whereabouts;


  WhereaboutsEntity({
    this.id,
    this.whereabouts,
    @required this.cost,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'cost': cost,
  };
  @override
  List<Object> get props => [id, cost, whereabouts];
}

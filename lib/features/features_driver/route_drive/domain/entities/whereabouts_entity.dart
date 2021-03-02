import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class WhereaaboutsEntity extends Equatable {
  final String id;
  final String province;
  final String adress;
  final String cost;
  final LatLng latLagFrom;
  final LatLng latLagTo;


  WhereaaboutsEntity({
    this.id,
    @required this.province,
    @required this.adress,
    @required this.cost,
    this.latLagFrom,
    this.latLagTo,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'province': province,
    'adress': adress,
    'cost': cost,
    'latLagFrom': latLagFrom,
    'latLagTo': latLagTo,
  };
  @override
  List<Object> get props => [id,province, cost, adress,latLagFrom,latLagTo];
}

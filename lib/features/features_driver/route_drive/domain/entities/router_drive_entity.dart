import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class RoutesEntity extends Equatable {
  final String id;
  final String name;
  final String nameFrom;
  final String nameTo;
  final LatLng latLagFrom;
  final LatLng latLagTo;


  RoutesEntity( {
    this.id,
    this.latLagFrom,
    this.latLagTo,
    this.name,
    @required this.nameFrom ,
    @required this.nameTo,
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'name': name,
    'nameFrom': nameFrom,
    'nameTo': nameTo,
    'latLagFrom': latLagFrom,
    'latLagTo': latLagTo,
  };

  factory RoutesEntity.fromJson(
    Map<String, dynamic> dataJson
  ){
    return RoutesEntity(
      id: dataJson['id'],
      name: dataJson['name'],
      nameFrom: dataJson['nameFrom'],
      nameTo: dataJson['nameTo'],
      latLagFrom: dataJson['latLagFrom'],
      latLagTo: dataJson['latLagTo'],
    );
  }
  factory RoutesEntity.empty({@required int orderBranch}) {
    return RoutesEntity(
      id: '',
      name: '',
      nameFrom: '',
      nameTo: '',
      latLagFrom: null,
      latLagTo: null,
    );
  }

  @override
  List<Object> get props => [id,name, nameFrom, nameTo,latLagFrom,latLagTo];
}

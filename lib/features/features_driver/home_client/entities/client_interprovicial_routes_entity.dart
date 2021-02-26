import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientInterporvincialRoutesEntity extends Equatable{
  final int id;
  final String nameDriver;
  final String from;
  final String to;
  final LatLng latLngfrom;
  final LatLng latLngto;

  ClientInterporvincialRoutesEntity({
    this.id,
    this.nameDriver,
    this.from,
    this.to,
    this.latLngfrom,
    this.latLngto
  });

  @override
  List<Object> get props => [id, nameDriver, from, to, latLngfrom, latLngto];
}
import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class LocationEntity extends Equatable {
  final LatLng latLang;
  final double zoom;
  final String name;

  LocationEntity({
    @required this.name,
    @required this.latLang,
    @required this.zoom,
  });

  factory LocationEntity.initalPeruPosition(){
    double latitude = -9.3346523;
    double longitude = -77.0692529;
    return LocationEntity(
      name: 'Perú',
      latLang: LatLng(latitude, longitude),
      zoom: 6.36
    );
  }
  
  @override
  List<Object> get props => [name, latLang, zoom];
}
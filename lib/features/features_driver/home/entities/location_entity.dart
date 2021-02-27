import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class LocationEntity extends Equatable {
  final LatLng latLang;
  final double zoom;
  final String streetName;
  final String districtName;
  final String provinceName;

  LocationEntity({
    @required this.streetName,
    @required this.districtName,
    @required this.provinceName,
    @required this.latLang,
    @required this.zoom,
  });

  factory LocationEntity.initalPeruPosition(){
    double latitude = -9.3346523;
    double longitude = -77.0692529;
    return LocationEntity(
      streetName: 'Perú',
      latLang: LatLng(latitude, longitude),
      zoom: 6.36,
      provinceName: 'Lima',
      districtName: 'Lima',
    );
  }
  
  @override
  List<Object> get props => [streetName, districtName, provinceName, latLang, zoom];
}
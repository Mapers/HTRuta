import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class LocationEntity extends Equatable {
  final LatLng latLang;
  final double zoom;
  final String streetName;
  final String districtName;
  final String provinceName;
  final String regionName;

  LocationEntity({
    @required this.streetName,
    @required this.districtName,
    @required this.provinceName,
    @required this.regionName,
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
      regionName: 'Lima',
    );
  }

  factory LocationEntity.initialWIthLocation({@required double latitude, @required double longitude}){
    return LocationEntity(
      latLang: LatLng(latitude, longitude),
      districtName: '-',
      provinceName: '-',
      streetName: '-',
      regionName: '-',
      zoom: 14
    );
  }

  LocationEntity copyWith({LatLng latLang, double zoom, String streetName, String districtName, String provinceName, String regionName}){
    return LocationEntity(
      latLang: latLang ?? this.latLang,
      zoom: zoom ?? this.zoom,
      streetName: streetName ?? this.streetName,
      districtName: districtName ?? this.districtName,
      provinceName: provinceName ?? this.provinceName,
      regionName: regionName ?? this.regionName,
    );
  }
  
  @override
  List<Object> get props => [streetName, districtName, provinceName, latLang, zoom];
}
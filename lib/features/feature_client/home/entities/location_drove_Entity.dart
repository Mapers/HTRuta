import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDriveEntity extends Equatable{
  final String regionName;
  final String districtName;
  final String street;
  final String fcmToken;
  final String status;
  final int availableSeats;
  final String provinceName;
  final LatLng coordenationDrive;

  LocationDriveEntity({
    this.regionName,
    this.districtName,
    this.street,
    this.fcmToken,
    this.status,
    this.availableSeats,
    this.provinceName,
    this.coordenationDrive,
  });

  @override
  List<Object> get props => [regionName, districtName, street, fcmToken, status, availableSeats, provinceName, coordenationDrive ];
}
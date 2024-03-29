import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class InterprovincialLocationDriverEntity extends Equatable{
  final String fcmToken;
  final String status;
  final String serviceId;
  final int availableSeats;
  final LocationEntity location;

  InterprovincialLocationDriverEntity({
    @required this.fcmToken,
    @required this.status,
    @required this.availableSeats,
    @required this.location,
    @required this.serviceId,
  });

  factory InterprovincialLocationDriverEntity.fromJson(Map<String, dynamic> dataJson){
    GeoPoint currentLocation = dataJson['current_location'];
    return InterprovincialLocationDriverEntity(
      availableSeats: dataJson['available_seats'],
      fcmToken: dataJson['fcm_token'],
      serviceId: dataJson['service_id'],
      location: LocationEntity(
        districtName: dataJson['district_name'],
        provinceName: dataJson['province_name'],
        regionName: dataJson['region_name'],
        streetName: dataJson['street'],
        latLang: LatLng(currentLocation.latitude, currentLocation.longitude),
      ),
      status: dataJson['status'],
    );
  }

  @override
  List<Object> get props => [ fcmToken, status, availableSeats, location, serviceId ];
}
import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class PassengerEntity extends Equatable {
  final String id;
  final String documentId;
  final String fullNames;
  final String urlImage;
  final String fcmToken;
  final int seats;
  final LocationEntity currentLocation;
  final LocationEntity toLocation;

  PassengerEntity({
    @required this.id,
    @required this.documentId,
    @required this.fullNames,
    @required this.currentLocation,
    @required this.toLocation,
    @required this.fcmToken,
    @required this.seats,
    @required this.urlImage,
  });

  factory PassengerEntity.fromJsonFirestore(Map<String, dynamic> dataJson){
    return PassengerEntity(
      id: dataJson['id'],
      documentId: dataJson['document_id'],
      fullNames: dataJson['full_names'],
      fcmToken: dataJson['fcm_token'],
      urlImage: dataJson['url_image'],
      seats: dataJson['seats'],
      currentLocation: LocationEntity(
        districtName: dataJson['to_district_name'],
        provinceName: dataJson['to_province_name'],
        regionName: dataJson['to_region_name'],
        streetName: dataJson['to_street_name'],
        latLang: LatLng(dataJson['to_location'].latitude, dataJson['to_location'].longitude)
      ),
      toLocation: LocationEntity(
        districtName: dataJson['to_district_name'],
        provinceName: dataJson['to_province_name'],
        regionName: dataJson['to_region_name'],
        streetName: dataJson['to_street_name'],
        latLang: LatLng(dataJson['to_location'].latitude, dataJson['to_location'].longitude)
      )
    );
  }
  factory PassengerEntity.fromJsonServer(Map<String, dynamic> dataJson, String documentId, String fcmToken){
    return PassengerEntity(
      id: dataJson['id'],
      documentId: documentId,
      fullNames: dataJson['full_names'],
      fcmToken: fcmToken,
      urlImage: dataJson['url_image'],
      seats: dataJson['seats'],
      currentLocation: LocationEntity(
        districtName: dataJson['current_district_name'],
        provinceName: dataJson['current_province_name'],
        regionName: dataJson['current_region_name'],
        streetName: dataJson['current_street_name'],
        latLang: LatLng(dataJson['current_location'].latitude, dataJson['current_location'].longitude)
      ),
      toLocation: LocationEntity(
        districtName: dataJson['to_district_name'],
        provinceName: dataJson['to_province_name'],
        regionName: dataJson['to_region_name'],
        streetName: dataJson['to_street_name'],
        latLang: LatLng(dataJson['to_location'].latitude, dataJson['to_location'].longitude)
      )
    );
  }

  Map<String, dynamic> get toFirestore => {
    'id': id,
    'full_names': fullNames,
    'url_image': urlImage,
    'seats': seats,
    'fcm_token': fcmToken,
    'current_location': GeoPoint(toLocation.latLang.latitude, toLocation.latLang.longitude),
    'current_district_name': toLocation.districtName,
    'current_province_name': toLocation.provinceName,
    'current_region_name': toLocation.regionName,
    'current_street_name': toLocation.streetName,
    'to_location': GeoPoint(toLocation.latLang.latitude, toLocation.latLang.longitude),
    'to_district_name': toLocation.districtName,
    'to_province_name': toLocation.provinceName,
    'to_region_name': toLocation.regionName,
    'to_street_name': toLocation.streetName,
  };

  String get destination => toLocation.streetName + ' - ' + toLocation.districtName + ' - ' + toLocation.provinceName + ' - ' + toLocation.regionName;

  factory PassengerEntity.mock(){
    return PassengerEntity(
      id: '1',
      documentId: 'LGSDFbEzf4WIP5GvGgKm',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      seats: 12,
      currentLocation: LocationEntity(
        latLang: LatLng(-11.114660, -77.594774),
        streetName: 'Antigua Panamericana Nte. 1035',
        districtName: 'Huacho',
        provinceName: 'Huaura',
        regionName: 'Lima',
        zoom: 12
      ),
      toLocation: LocationEntity(
        latLang: LatLng(-11.114660, -77.594774),
        streetName: 'Antigua Panamericana Nte. 1035',
        districtName: 'Huacho',
        provinceName: 'Huaura',
        regionName: 'Lima',
        zoom: 12
      ),
      urlImage: 'https://source.unsplash.com/1600x900/?portrait',
      fcmToken: 'dr3TmNBFSxixWmx5vc2p_Z:APA91bFTY9z3Bp442nsWKlaeaeKaq4TsjKc6XlnBUeqWrUnNY7ZvTazP4Fx3Jvj5MRsdkZiMoE7a3dJKv-yYq_9hx6_8qmT8ryWB0kJ5FnRAzjdKPDHp93ysfkqOcQ4SuCp98m14aiiL'
    );
  }

  @override
  List<Object> get props => [id, documentId, fullNames, toLocation, currentLocation, urlImage, seats, fcmToken];
}
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
  final String cellPhone;
  final double price;
  final LocationEntity currentLocation;
  final LocationEntity toLocation;
  final int distanceInMinutes;
  final double distanceInMeters;
  final PassengerStatus status;
  final GeoPoint pointMeeting;

  PassengerEntity({
    @required this.id,
    @required this.documentId,
    @required this.fullNames,
    @required this.toLocation,
    @required this.fcmToken,
    @required this.seats,
    @required this.urlImage,
    @required this.price,
    @required this.distanceInMinutes,
    @required this.distanceInMeters,
    @required this.status,
    @required this.cellPhone,
    this.currentLocation,
    this.pointMeeting
  });

  factory PassengerEntity.fromJsonFirestore(Map<String, dynamic> dataJson){
    LocationEntity _currentLocation;
    if(dataJson['current_location'] != null){
      _currentLocation = LocationEntity(
        districtName: dataJson['current_district_name'],
        provinceName: dataJson['current_province_name'],
        regionName: dataJson['current_region_name'],
        streetName: dataJson['current_street_name'],
        latLang: LatLng(dataJson['current_location'].latitude, dataJson['current_location'].longitude)
      );
    }
    return PassengerEntity(
      id: dataJson['id'],
      documentId: dataJson['document_id'],
      fullNames: dataJson['full_names'],
      fcmToken: dataJson['fcm_token'],
      urlImage: dataJson['url_image'] ?? 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500&h=500',
      seats: dataJson['seats'],
      price: dataJson['price'],
      cellPhone: dataJson['passenger_phone'],
      distanceInMeters: (dataJson['distance_in_meters'] as num).toDouble(),
      distanceInMinutes: (dataJson['distance_in_minutes'] as num).toInt(),
      currentLocation: _currentLocation,
      toLocation: LocationEntity(
        districtName: dataJson['to_district_name'],
        provinceName: dataJson['to_province_name'],
        regionName: dataJson['to_region_name'],
        streetName: dataJson['to_street_name'],
        latLang: LatLng(dataJson['to_location'].latitude, dataJson['to_location'].longitude)
      ),
      status: getPassengerStatusFromString(dataJson['status'])
    );
  }

  factory PassengerEntity.fromQueryDocumentSnapshot(QueryDocumentSnapshot queryDocumentSnapshot){
    final data = queryDocumentSnapshot.data();
    data['document_id'] = queryDocumentSnapshot.id;
    return PassengerEntity.fromJsonFirestore(data);
  }

  factory PassengerEntity.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    final data = documentSnapshot.data();
    data['document_id'] = documentSnapshot.id;
    return PassengerEntity.fromJsonFirestore(data);
  }

  factory PassengerEntity.fromJsonServer(Map<String, dynamic> dataJson, String documentId, String fcmToken){
    dynamic toLocation = dataJson['to_location'];
    return PassengerEntity(
      id: dataJson['id'],
      documentId: documentId,
      fullNames: dataJson['full_name'],
      fcmToken: fcmToken,
      urlImage: dataJson['url_image'],
      seats: int.parse(dataJson['seats'] as String),
      price: dataJson['price'] ?? -1,
      cellPhone: dataJson['passenger_phone'],
      distanceInMeters: 0,
      distanceInMinutes: 0,
      currentLocation: null,
      toLocation: LocationEntity(
        districtName: toLocation['district_name'],
        provinceName: toLocation['province_name'],
        regionName: toLocation['region_name'],
        streetName: toLocation['street_name'],
        latLang: LatLng(
          double.parse(toLocation['latitude'] as String),
          double.parse(toLocation['longitude'] as String)
        )
      ),
      status: getPassengerStatusFromString(dataJson['status'])
    );
  }

  Map<String, dynamic> get toFirestore {
    Map<String, dynamic> struct = {
      'id': id,
      'full_names': fullNames,
      'url_image': urlImage,
      'seats': seats,
      'fcm_token': fcmToken,
      'distance_in_meters': distanceInMeters,
      'distance_in_minutes': distanceInMinutes,
      'price': price,
      'passenger_phone': cellPhone,
      'to_location': GeoPoint(toLocation.latLang.latitude, toLocation.latLang.longitude),
      'to_district_name': toLocation.districtName,
      'to_province_name': toLocation.provinceName,
      'to_region_name': toLocation.regionName,
      'to_street_name': toLocation.streetName,
      'status': getPassengerStatusFromEnum(status),
      'pointMeeting':pointMeeting
    };
    if(currentLocation != null){
      struct['current_location'] = GeoPoint(currentLocation.latLang.latitude, currentLocation.latLang.longitude);
      struct['current_district_name'] = currentLocation.districtName;
      struct['current_province_name'] = currentLocation.provinceName;
      struct['current_region_name'] = currentLocation.regionName;
      struct['current_street_name'] = currentLocation.streetName;
    }
    return struct;
  }

  String get destination {
    if(toLocation == null) return 'No mapeado';
    return toLocation.streetName + ' - ' + toLocation.districtName + ' - ' + toLocation.provinceName + ' - ' + toLocation.regionName;
  }

  PassengerEntity copyWith({ String id, String documentId, String fullNames, LocationEntity currentLocation, LocationEntity toLocation, String fcmToken, int seats, double price, String urlImage, String distanceInMinutes, String distanceInMeters, PassengerStatus status, GeoPoint pointMeeting}){
    return PassengerEntity(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      fullNames: fullNames ?? this.fullNames,
      currentLocation: currentLocation ?? this.currentLocation,
      toLocation: toLocation ?? this.toLocation,
      fcmToken: fcmToken ?? this.fcmToken,
      seats: seats ?? this.seats,
      price: price ?? this.price,
      urlImage: urlImage ?? this.urlImage,
      distanceInMinutes: distanceInMinutes ?? this.distanceInMinutes,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      status: status ?? this.status,
      pointMeeting: pointMeeting ?? this.pointMeeting
    );
  }

  factory PassengerEntity.mock(){
    return PassengerEntity(
      id: '1',
      documentId: 'LGSDFbEzf4WIP5GvGgKm',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      seats: 12,
      price: 10,
      distanceInMeters: 2031,
      distanceInMinutes: 1200,
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
      fcmToken: 'dr3TmNBFSxixWmx5vc2p_Z:APA91bFTY9z3Bp442nsWKlaeaeKaq4TsjKc6XlnBUeqWrUnNY7ZvTazP4Fx3Jvj5MRsdkZiMoE7a3dJKv-yYq_9hx6_8qmT8ryWB0kJ5FnRAzjdKPDHp93ysfkqOcQ4SuCp98m14aiiL',
      status: PassengerStatus.actived
    );
  }

  @override
  List<Object> get props => [id, documentId, fullNames, currentLocation, toLocation, distanceInMeters, distanceInMinutes, urlImage, seats, fcmToken, price];
}

enum PassengerStatus {
  actived, deleted
}

String getPassengerStatusFromEnum(PassengerStatus status){
  switch (status) {
    case PassengerStatus.actived:
    return 'ACTIVED';
    case PassengerStatus.deleted:
    return 'DELETED';
  }
  return '-';
}

PassengerStatus getPassengerStatusFromString(String status){
  switch (status) {
    case 'ACTIVED':
    return PassengerStatus.actived;
    case 'DELETED':
    return PassengerStatus.deleted;
  }
  return null;
}
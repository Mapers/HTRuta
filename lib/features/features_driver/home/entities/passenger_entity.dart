import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class PassengerEntity extends Equatable {
  final String documentId;
  final String fullNames;
  final String urlImage;
  final int seats;
  final LocationEntity toLocation;

  PassengerEntity({
    @required this.documentId,
    @required this.fullNames,
    @required this.toLocation,
    @required this.seats,
    @required this.urlImage,
  });

  factory PassengerEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return PassengerEntity(
      documentId: dataJson['id'],
      fullNames: dataJson['full_names'],
      urlImage: dataJson['url_image'],
      seats: dataJson['seats'],
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
    'full_names': fullNames,
    'url_image': urlImage,
    'seats': seats,
    'to_location': GeoPoint(toLocation.latLang.latitude, toLocation.latLang.longitude),
    'to_district_name': toLocation.districtName,
    'to_province_name': toLocation.provinceName,
    'to_region_name': toLocation.regionName,
    'to_street_name': toLocation.streetName,
  };

  String get destination => toLocation.streetName + ' - ' + toLocation.districtName + ' - ' + toLocation.provinceName + ' - ' + toLocation.regionName;

  factory PassengerEntity.mock(){
    return PassengerEntity(
      documentId: 'LGSDFbEzf4WIP5GvGgKm',
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      seats: 12,
      toLocation: LocationEntity(
        latLang: LatLng(-11.114660, -77.594774),
        streetName: 'Antigua Panamericana Nte. 1035',
        districtName: 'Huacho',
        provinceName: 'Huaura',
        regionName: 'Lima',
        zoom: 12
      ),
      urlImage: 'https://source.unsplash.com/1600x900/?portrait'
    );
  }

  @override
  List<Object> get props => [documentId, fullNames, toLocation, urlImage, seats];
}
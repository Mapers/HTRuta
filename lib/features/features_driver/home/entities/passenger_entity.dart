import 'package:HTRuta/features/DriverTaxiApp/data/equatable.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class PassengerEntity extends Equatable {
  final String fullNames;
  final String urlImage;
  final int seats;
  final LocationEntity location;

  PassengerEntity({
    @required this.fullNames,
    @required this.location,
    @required this.seats,
    @required this.urlImage,
  });

  factory PassengerEntity.fromJsonLocal(Map<String, dynamic> dataJson){
    return PassengerEntity(
      fullNames: dataJson['full_names'],
      urlImage: dataJson['url_image'],
      seats: dataJson['seats'],
      location: LocationEntity(
        districtName: dataJson['district_name'],
        provinceName: dataJson['province_name'],
        regionName: dataJson['region_name'],
        streetName: dataJson['street_name'],
        latLang: LatLng(dataJson['location'].latitude, dataJson['location'].longitude)
      )
    );
  }

  factory PassengerEntity.test(){
    return PassengerEntity(
      fullNames: 'Luis Eduardo del Prado Rivadeneira',
      seats: 12,
      location: LocationEntity(
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
  List<Object> get props => [fullNames, location, urlImage];
}
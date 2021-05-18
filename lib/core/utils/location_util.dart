import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:HTRuta/entities/location_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtil {

  static Future<LocationEntity> currentLocation() async {
    Position currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    LocationEntity locationEntity = LocationEntity.initialWithLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark pos = placemarks.first;
      locationEntity = locationEntity.copyWith(
        streetName: pos.thoroughfare + (pos.subThoroughfare?.toString()),
        districtName: pos.locality,
        provinceName: pos.subAdministrativeArea
      );
    }
    return locationEntity;
  }

  StreamSubscription subscription;

  void initListener({@required Function(LocationEntity) listen}){
    subscription = Geolocator.getPositionStream().listen((location) async{
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      LocationEntity locationEntity = LocationEntity.initialWithLocation(latitude: location.latitude, longitude: location.longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark pos = placemarks.first;
        locationEntity = locationEntity.copyWith(
          streetName: pos.thoroughfare + (pos.subThoroughfare?.toString()),
          districtName: pos.locality,
          provinceName: pos.subAdministrativeArea,
          regionName: pos.administrativeArea
        );
      }
      listen(locationEntity);
    });
  }

  void disposeListener() => subscription?.cancel();

  static double calculateDistanceInKilometers(LatLng from, LatLng to){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((to.latitude - from.latitude) * p)/2 +
          c(from.latitude * p) * c(to.latitude * p) *
          (1 - c((to.longitude - from.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  static double calculateDistanceInMeters(LatLng from, LatLng to){
    return calculateDistanceInKilometers(from, to) * 1000;
  }

  /// In kilometers
  static double calculateDistanceInListPoints(List<LatLng> list){
    List<LatLng> _list = [...list];
    double distance = 0;
    if(list.isEmpty || list.length == 1) return 0;
    do {
      distance += calculateDistanceInKilometers(_list.first, _list[1]);
      _list.removeAt(0);
    } while (_list.length != 1);
    return distance;
  }

  static double kilometersToMeters(double distanceInKms) => distanceInKms * 1000;
}
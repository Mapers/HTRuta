import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:HTRuta/entities/location_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtil {

  static Future<LocationEntity> currentLocation() async {
    try{
      Position currentLoc = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      LocationEntity locationEntity = LocationEntity.initialWithLocation(latitude: currentLoc.latitude, longitude: currentLoc.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(currentLoc?.latitude, currentLoc?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark pos = placemarks.first;
        locationEntity = locationEntity.copyWith(
          streetName: pos.thoroughfare + (pos.subThoroughfare?.toString()),
          districtName: pos.locality,
          provinceName: pos.subAdministrativeArea
        );
      }
      return locationEntity;
    }catch(_){
      Position currentLoc = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      return LocationEntity(
        streetName: '',
        districtName: '',
        provinceName: '',
        regionName: '',
        latLang: LatLng(currentLoc?.latitude, currentLoc?.longitude)
      );
    }
  }

  StreamSubscription subscription;

  void initListener({@required Function(LocationEntity) listen}){
    subscription = Geolocator.getPositionStream(distanceFilter: 15).listen((location) async{
      try{
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
        listen(locationEntity.formatNames);

      }catch(e){
        print(e);
      }
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

  static double calculateDistanceInMeters(LatLng from, LatLng to) => calculateDistanceInKilometers(from, to) * 1000;

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
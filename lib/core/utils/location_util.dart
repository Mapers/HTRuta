import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:HTRuta/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtil {

  static Future<LocationEntity> currentLocation() async {
    Geolocator _locationService = Geolocator();
    Position currentLocation = await _locationService.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    LocationEntity locationEntity = LocationEntity.initialWithLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude);

    List<Placemark> placemarks = await _locationService.placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
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
    Geolocator _locationService = Geolocator();
    subscription = _locationService.getPositionStream().listen((location) async{
      List<Placemark> placemarks = await _locationService.placemarkFromCoordinates(location.latitude, location.longitude);
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

  void disposeListener(){
    subscription?.cancel();
  }

  /// In kilometers
  static double calculateDistance(LatLng from, LatLng to){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((to.latitude - from.latitude) * p)/2 + 
          c(from.latitude * p) * c(to.latitude * p) * 
          (1 - c((to.longitude - from.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  
}
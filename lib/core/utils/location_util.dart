import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtil {

  static Future<LocationEntity> currentLocation() async {
    Geolocator _locationService = Geolocator();
    Position currentLocation = await _locationService.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    String name = '';

    List<Placemark> placemarks = await _locationService.placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark pos = placemarks[0];
      name = pos.name + ', ' + pos.thoroughfare;
    }
    return LocationEntity(
      streetName: name,
      districtName: '-',
      provinceName: '-',
      latLang: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14
    );
  }

  StreamSubscription subscription;

  void initListener({@required Function(LocationEntity) listen}){
    Geolocator _locationService = Geolocator();
    subscription = _locationService.getPositionStream().listen((location) async{
      List<Placemark> placemarks = await _locationService.placemarkFromCoordinates(location.latitude, location.longitude);
      String name = '-';
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark pos = placemarks[0];
        name = pos.name + ', ' + pos.thoroughfare;
      }
      listen(LocationEntity(
        latLang: LatLng(location.latitude, location.longitude),
        districtName: '-',
        provinceName: '-',
        streetName: name,
        zoom: 14
      ));
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
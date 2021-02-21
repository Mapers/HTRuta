import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart';
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
      name: name,
      latLang: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14
    );
  }
  
}
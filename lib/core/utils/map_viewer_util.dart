import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewerUtil {
  MarkerId markerLocation = MarkerId('DRIVER_LOCATION');
  MarkerId markerFrom = MarkerId('DRIVER_FROM_LOCATION');
  MarkerId markerTo = MarkerId('DRIVER_TO_LOCATION');

  GoogleMapController googleMapController;

  Widget build({
    @required double height,
    @required Map<MarkerId, Marker> markers,
    @required LatLng currentLocation,
    Map<PolylineId, Polyline> polyLines = const <PolylineId, Polyline>{},
    ArgumentCallback<LatLng> onTap,
  }) {
    return SizedBox(
      height: height,
      child: GoogleMap(
        onMapCreated:(mapContext){
          googleMapController = mapContext;
        },
        onTap: onTap,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polyLines.values),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        indoorViewEnabled: false,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: _getCurrentPosition(currentLocation),
      ),
    );
  }

  CameraPosition _getCurrentPosition(LatLng currentLocation){
    LatLng latLng = LatLng(0, 0);
    if(currentLocation != null){
      latLng = currentLocation;
    }
    return CameraPosition(
      target: latLng,
      zoom: 12,
    );
  }

  void cameraMoveLatLngZoom(LatLng location, {double zoom = 16}) async {
    return googleMapController?.animateCamera(
      CameraUpdate?.newLatLngZoom(
        location,
        zoom,
      ),
    );
  }

  void cameraMoveBound({
    @required LatLng fromLocation,
    @required LatLng toLocation,
  }) async {
    var _latFrom = fromLocation.latitude;
    var _lngFrom = fromLocation.longitude;
    var _latTo = toLocation.latitude;
    var _lngTo = toLocation.longitude;
    var sLat, sLng, nLat, nLng;

    if(_latFrom <= _latTo) {
      sLat = _latFrom;
      nLat = _latTo;
    } else {
      sLat = _latTo;
      nLat = _latFrom;
    }

    if(_lngFrom <= _lngTo) {
      sLng = _lngFrom;
      nLng = _lngTo;
    } else {
      sLng = _lngTo;
      nLng = _lngFrom;
    }


    return googleMapController?.animateCamera(
      CameraUpdate?.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(sLat, sLng),
          northeast: LatLng(nLat, nLng),
        ),
        120,
      ),
    );
  }

  Marker generateMarker({@required LatLng latLng, @required String nameMarkerId, BitmapDescriptor icon, Function onTap}) {
    MarkerId markerId = MarkerId(nameMarkerId);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      draggable: false,
      icon: icon,
      onTap: onTap
    );
    return marker;
  }
}

import 'package:HTRuta/features/ClientTaxiApp/Components/decodePolyline.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapViewHelper {

  GMapViewHelper();

  Widget buildMapView({
    @required BuildContext context,
    @required Map<MarkerId, Marker> markers,
    Map<PolylineId, Polyline> polyLines = const <PolylineId, Polyline>{},
    MapCreatedCallback onMapCreated,
    ArgumentCallback<LatLng> onTap,
    @required LatLng currentLocation,
    bool myLocationEnabled = true
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        onMapCreated: onMapCreated,
        onTap: onTap,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polyLines.values),
        myLocationEnabled: myLocationEnabled,
        myLocationButtonEnabled: false,
        indoorViewEnabled: false,
        mapToolbarEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 12,
        ),
      ),
    );
  }

  static Marker createMaker ({
    @required String markerIdVal,
    @required String icon,
    @required double lat,
    @required double lng, GestureTapCallback onTap,}){
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        // ignore: deprecated_member_use
        icon: BitmapDescriptor.fromAsset(icon),
        onTap: onTap
    );

    return marker;
  }

  static Polyline createPolyline ({
    @required String polylineIdVal,
    @required final router,
    @required LatLng formLocation,
    @required LatLng toLocation,
  }){
    List<LatLng> listPoints = <LatLng>[];
    List<dynamic> _points = <dynamic>[];
    List<dynamic> latLong = <dynamic>[];
    List<dynamic> lngLong = <dynamic>[];
    final PolylineId polylineId = PolylineId(polylineIdVal);

    LatLng _createLatLng(double lat, double lng) {
      return LatLng(lat, lng);
    }

    var _router = decode(router);
    for (int lat = 0; lat < _router.length; lat += 2) {
      latLong.add(_router[lat]);
    }
    for (int lng = 1; lng < _router.length; lng += 2) {
      lngLong.add(_router[lng]);
    }
    for (int i = 0; i < latLong.length; i++) {
      _points.add([latLong[i], lngLong[i]]);
    }
    for (int i = 0; i < _points.length; i++) {
      listPoints.add(_createLatLng(_points[i][0], _points[i][1]));
    }

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Color(0xFF669df6),
      width: 6,
      points: listPoints,
    );
    return polyline;
  }

  void cameraMove({
    @required LatLng fromLocation,
    @required LatLng toLocation,
    @required GoogleMapController mapController,

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

    return mapController?.animateCamera(
      CameraUpdate?.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(sLat, sLng),
          northeast: LatLng(nLat, nLng),
        ),
        120.0,
      ),
    );
  }
}

import 'package:HTRuta/config.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewerUtil {

  GoogleMapController googleMapController;

  Widget build({
    @required double height,
    @required Map<MarkerId, Marker> markers,
    @required LatLng currentLocation,
    bool drawCircle,
    double radiusCircle,

    double zoom = 16,
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
        initialCameraPosition: _getCurrentPosition(currentLocation, zoom: zoom),
        // ignore: prefer_collection_literals
        circles: Set<Circle>.from([circular(currentLocation, visible: drawCircle,radiusCircle: radiusCircle)]),
      ),
    );
  }

  Circle circular(LatLng currentLocation,{bool visible = false,double  radiusCircle = 4000}){
    Circle circles =
      Circle(
        
        visible: visible,
        circleId: CircleId('1'),
        center: LatLng(currentLocation.latitude, currentLocation.longitude),
        radius: radiusCircle,
        strokeWidth: 1
      );
      return circles;
  }

  CameraPosition _getCurrentPosition(LatLng currentLocation,{double zoom = 12}){
    LatLng latLng = LatLng(0, 0);
    if(currentLocation != null){
      latLng = currentLocation;
    }
    return CameraPosition(
      target: latLng,
      zoom: zoom,
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

  Future<Polyline> generatePolyline(String namePolylineId, LocationEntity from, LocationEntity to, {MaterialColor color = Colors.blue}) async{
    PolylinePoints polylinePoints = PolylinePoints();
    PointLatLng fromPoint = PointLatLng(from.latLang.latitude, from.latLang.longitude);
    PointLatLng toPoint = PointLatLng(to.latLang.latitude, to.latLang.longitude);
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Config.googleMapsApiKey,
      fromPoint, toPoint
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      PolylineId id = PolylineId(namePolylineId);
      Polyline polyline = Polyline(polylineId: id, color: color, points: polylineCoordinates, width: 3);
      return polyline;
    }
    return null;
  }
}

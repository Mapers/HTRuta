import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/utils/colors_util.dart';
import 'package:HTRuta/core/utils/file_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        onMapCreated:(mapContext) => googleMapController = mapContext,
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

  void get changeToDarkMode => changeMapType(3, 'assets/style/dark_mode.json');

  void changeMapType(int id, String fileName){
    if (fileName == null) {
      googleMapController.setMapStyle(null);
    } else {
      _getFileData(fileName)?.then((mapStyle) => googleMapController.setMapStyle(mapStyle));
    }
  }

  Future<String> _getFileData(String path) async => await rootBundle.loadString(path);

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

  static Marker generateMarker({@required LatLng latLng, @required String nameMarkerId, BitmapDescriptor icon, Function onTap, String title}) {
    MarkerId markerId = MarkerId(nameMarkerId);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      draggable: false,
      icon: icon,
      onTap: onTap,
      infoWindow: title != null ? InfoWindow(
        title: nameMarkerId
      ) : InfoWindow.noText
    );
    return marker;
  }

  Future<Polyline> generatePolyline(String namePolylineId, LocationEntity from, LocationEntity to, { MaterialColor color }) async{
    color ??= MaterialColor(primaryColor.value, ColorsUtil.getSwatch(primaryColor));
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


  /// Reference: https://stackoverflow.com/questions/56597739/how-to-customize-google-maps-marker-icon-in-flutter
  static Future<BitmapDescriptor> getMarkerIcon(String imagePath, { Size size }) async {
    size ??= Size(120, 120);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = primaryColor.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            0.0,
            0.0,
            size.width,
            size.height
        ),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

    // Add border circle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          shadowWidth,
          shadowWidth,
          size.width - (shadowWidth * 2),
          size.height - (shadowWidth * 2)
        ),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      borderPaint
    );

    // Oval for the image
    Rect oval = Rect.fromLTWH(
      imageOffset,
      imageOffset,
      size.width - (imageOffset * 2),
      size.height - (imageOffset * 2)
    );

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    FileUtil fileUtil = FileUtil();

    // Add image
    ui.Image image = await fileUtil.getImageFromPath(imagePath, size); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt()
    );

    // Convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
}

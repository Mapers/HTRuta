import 'package:HTRuta/features/features_driver/route_drive/presentation/widgets/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  FocusNode _focus = new FocusNode();

  AppState() {
    _getUserLocation();
    _loadingInitialPosition();
  }
// ! TO GET THE USERS LOCATION
  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    // locationController.text = placemark[0].locality;
    notifyListeners();
  }

  createpoint({LatLng pos, bool inputSelecter}) async{
    print(inputSelecter);
    if(inputSelecter){
      List<Placemark> placeMarkOrigin= await Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);
      _addMarker(pos,placeMarkOrigin[0].locality);
      locationController.text = placeMarkOrigin[0].locality;
    }else{
      print("entre");
      List<Placemark> placeMarkDestination= await Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);
      _addMarker(pos,placeMarkDestination[0].locality);
      destinationController.text = placeMarkDestination[0].locality;
    }
    // print(markers.length);
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 5,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red));
    notifyListeners();
  }

  // ! ADD A MARKER ON THE MAO
  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
      markerId: MarkerId(_lastPosition.toString()),
      position: location,
      infoWindow: InfoWindow(title: address, snippet: "go here"),
      icon: BitmapDescriptor.defaultMarker)
    );
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());
    return lList;
  }

  // ! SEND REQUEST
  void sendRequest({String txtOrigen,String txtDestination }) async {
    List<Placemark> placemarkDestination = await Geolocator().placemarkFromAddress(txtDestination);
    double latitude = placemarkDestination[0].position.latitude;
    double longitude = placemarkDestination[0].position.longitude;

    List<Placemark> placemarkOrigen = await Geolocator().placemarkFromAddress(txtOrigen);
    double latitudeOrigen = placemarkOrigen[0].position.latitude;
    double longitudeOrigen = placemarkOrigen[0].position.longitude;
    LatLng origen = LatLng(latitudeOrigen, longitudeOrigen);
    LatLng destination = LatLng(latitude, longitude);
    String route = await _googleMapsServices.getRouteCoordinates( origen , destination );

    markers.clear();
    polyLines.clear();
    _addMarker(origen, txtOrigen);
    _addMarker(destination, txtDestination);
    createRoute(route);
    print(_polyLines);
    print(_markers);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

//  LOADING INITIAL POSITION
  void _loadingInitialPosition()async{
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
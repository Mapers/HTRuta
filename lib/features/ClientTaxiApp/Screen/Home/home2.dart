/* import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class HomeScreen2 extends StatefulWidget {
  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  _HomeScreen2State();
  final String screenName = 'HOME2';
  var _scaffoldKey =GlobalKey<ScaffoldState>();
  List<LatLng> points = <LatLng>[];
  GoogleMapController _mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  MarkerId selectedMarker;
  BitmapDescriptor _markerIcon;
  CircleId selectedCircle;

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  PolylineId selectedPolyline;
  bool checkPlatform = Platform.isIOS;
  Position _position;
  String placemark = '';
  double distance = 0;
  LatLng currentLocation = LatLng(-8.098452, -79.008016);
  List<Map<String, dynamic>> listDistance = [{'id': 1, 'title': '500 m'},{'id': 2, 'title': '1 km'},{'id':3,'title': '3 km'}];
  String selectedDistance = '1';
  double _radius = 500;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  List<dynamic> dataMarKer = [
    {
      'id': '1',
      'lat': -8.095180,
      'lng':  -79.015397
    },{
      'id': '2',
      'lat': -8.102633,
      'lng': -79.017507
    },{
      'id': '3',
      'lat': -8.109202,
      'lng': -79.012449,
    },{
      'id': '4',
      'lat': -8.112092,
      'lng': -79.019249
    },{
      'id': '5',
      'lat': -8.117724,
      'lng': -79.015037
    },{
      'id': '6',
      'lat': -8.117044,
      'lng': -79.007141,
    },{
      'id': '7',
      'lat': -8.126110,
      'lng': -79.030460
    }
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(
        CameraUpdate?.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude,currentLocation.longitude),
              zoom: 15,
            )
        )
    );
    _addCircle();

    for(int i=0;i<dataMarKer.length;i++){
      distance = calculateDistance(currentLocation.latitude,currentLocation.longitude,dataMarKer[i]['lat'],dataMarKer[i]['lng']);
      if(distance*1000 < _radius){
        _addMarker(dataMarKer[i]['id'], dataMarKer[i]['lat'], dataMarKer[i]['lng']);
      }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _position = position;

    });
    List<Placemark> placemarks = await placemarkFromCoordinates(_position.latitude, _position.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        placemark = pos.thoroughfare + ', ' + pos.locality;

      });
    }
  }


  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
          imageConfiguration, checkPlatform ? 'assets/image/marker/car_top_48.png' : 'assets/image/marker/car_top_96.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  void _addMarker(String markerIdVal, double lat, double lng) async {
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/car_top_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/car_top_96.png'),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addCircle() {
    final int circleCount = circles.length;
    if (circleCount == 12) {
      return;
    }
    final String circleIdVal = 'circle_id';
    final CircleId circleId = CircleId(circleIdVal);

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: Color.fromRGBO(135, 206, 250, 0.9),
      fillColor: Color.fromRGBO(135, 206, 250, 0.3),
      strokeWidth: 4,
      center: LatLng(currentLocation.latitude,currentLocation.longitude),
      radius: _radius,
    );
    setState(() {
      circles[circleId] = circle;
    });
  }

  /// Widget change the radius Circle.

  Widget getListOptionDistance() {
    final List<Widget> choiceChips = listDistance.map<Widget>((value) {
      return Padding(
          padding: const EdgeInsets.all(3.0),
          child: ChoiceChip(
              key: ValueKey<String>(value['id'].toString()),
              labelStyle: textGrey,
              backgroundColor: greyColor2,
              selectedColor: primaryColor,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              selected: selectedDistance == value['id'].toString(),
              label: Text((value['title'])),
              onSelected: (bool check) {
                setState(() {
                  selectedDistance = check ? value['id'].toString() : '';
                  changeCircle(selectedDistance);
                });
              })
      );
    }).toList();
    return Wrap(
        children: choiceChips
    );
  }

  ///Filter and display markers in that area
  ///My data is demo. You can get data from your api and use my function
  ///to filter and display markers around the current location.

  void changeCircle(String selectedCircle){
    if(selectedCircle == '1'){
      setState(() {
        _radius = 500;
        _moveCamera(14);
      });
    }
    if(selectedCircle == '2'){
      setState(() {
        _radius = 1000;
        _moveCamera(13.9);
      });
    }
    if(selectedCircle == '3'){
      setState(() {
        _radius = 3000;
        _moveCamera(13);
      });
    }
    _addCircle();
    for(int i=0;i<dataMarKer.length;i++){
      distance = calculateDistance(currentLocation.latitude,currentLocation.longitude,dataMarKer[i]['lat'],dataMarKer[i]['lng']);
      if(distance*1000 < _radius){
        _addMarker(dataMarKer[i]['id'], dataMarKer[i]['lat'], dataMarKer[i]['lng']);
      } else {
        _remove(dataMarKer[i]['id']);
      }
    }
  }

  void _remove(String idMarker) {
    final MarkerId markerId = MarkerId(idMarker);
    setState(() {
      markers.remove(markerId);
    });
  }

  void _moveCamera(double zoom){
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude,currentLocation.longitude),
            zoom: zoom,
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
      key: _scaffoldKey,
      drawer: MenuScreens(activeScreenName: screenName),
      body:Container(
        color: Colors.white,
        child: SingleChildScrollView(
            child:Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: GoogleMap(
                          circles: Set<Circle>.of(circles.values),
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation.latitude,currentLocation.longitude),
                            zoom: 12,
                          ),
                          markers: Set<Marker>.of(markers.values),
                        )
                    ),

                  ],
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        centerTitle: true,
                        leading: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            final _state = _sideMenuKey.currentState;
                            if (_state.isOpened)
                              _state.closeSideMenu(); // close side menu
                            else
                              _state.openSideMenu();// open side menu
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0,right: 10.0),
                        child: getListOptionDistance(),
                      )
                    ],
                  ),
                ),

              ],
            )
        ),
      ),
    )
    );
  }
}
 */
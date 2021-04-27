import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/loading.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  var _scaffoldKey =GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  GoogleMapController _mapController;

  String currentLocationName;
  String newLocationName;
  Position _currentPosition;
  String _placemark = '';
  GoogleMapController mapController;
  CameraPosition _position;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      _currentPosition = position;
      print(_currentPosition.longitude);
      print(_currentPosition.latitude);
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.name + ', ' + pos.thoroughfare;
        print(_placemark);
        currentLocationName = _placemark;
      });
    }
  }

  void getLocationName(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.name + ', ' + pos.thoroughfare;
        newLocationName = _placemark;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(21.00349833333333,  105.849);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
    );
    setState(() {
      _markers[markerId] = marker;
    });
    Future.delayed(Duration(milliseconds: 200), () async {
      _mapController = controller;
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 17.0,
          ),
        ),
      );
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void submitLocation(){
    print(_position);
    print(newLocationName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _currentPosition == null ? Container(
        child: LoadingBuilder(),
      ): Container(
        color: whiteColor,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height - 50,
                  child: GoogleMap(
                    markers: Set<Marker>.of(_markers.values),
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      // ignore: prefer_if_null_operators
                      target: LatLng(_currentPosition.latitude != null ? _currentPosition.latitude : 0.0, _currentPosition.longitude != null ? _currentPosition.longitude : 0.0),
                      zoom: 12.0,
                    ),
                    onCameraMove: (CameraPosition position) {
                      if(_markers.isNotEmpty) {
                        MarkerId markerId = MarkerId(_markerIdVal());
                        Marker marker = _markers[markerId];
                        Marker updatedMarker = marker.copyWith(
                          positionParam: position.target,
                        );
                        setState(() {
                          _markers[markerId] = updatedMarker;
                          _position = position;
                        });
                      }
                    },
                    onCameraIdle: () => getLocationName(
                        // ignore: prefer_if_null_operators
                        // ignore: prefer_if_null_operators
                        _position.target.latitude != null ? _position.target.latitude : _currentPosition.latitude,
                        // ignore: prefer_if_null_operators
                        _position.target.longitude != null ? _position.target.longitude : _currentPosition.longitude
                    ),
                  ),
                ),
                Container(
                    height: 50.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width - 50.0,
                            height: 45.0,
                            child: RaisedButton(
                              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
                              elevation: 0.0,
                              color: primaryColor,
                              child:Text('SUBMIT',style: headingWhite,
                              ),
                              onPressed: (){
                                submitLocation();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
            Positioned(
              bottom: 70,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.my_location,size: 30.0,),
                onPressed: (){
                  _mapController?.animateCamera(
                    CameraUpdate?.newCameraPosition(
                      CameraPosition(
                        // ignore: prefer_if_null_operators
                        target: LatLng(_currentPosition.latitude != null ? _currentPosition.latitude : 0.0, _currentPosition.longitude != null ? _currentPosition.longitude : 0.0),
                        zoom: 17.0,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    title: _position != null ?
                    // ignore: prefer_if_null_operators
                    Text(newLocationName != null ? newLocationName : '',style: textStyle)
                        : Text(currentLocationName,style: textStyle,),
                    leading: FlatButton(
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Icon(Icons.menu,color: blackColor,)
                    ),
//                      actions: <Widget>[
//                        Icon(Icons.notifications,color: blackColor,)
//                      ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

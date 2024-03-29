import 'dart:async';
import 'dart:io' show Platform;

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/models/map_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/select_address_view.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SearchAddress/search_address_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'select_map_type.dart';

class HomeView extends StatefulWidget {
  final ClientTaxiPlaceBloc placeBloc;
  HomeView({this.placeBloc});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String screenName = 'HOME';
  var _scaffoldKey =GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  int _markerIdCounter = 0;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  String _placemark = '';
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = [];
  PersistentBottomSheetController _controller;

  Position currentLocation;
  Position _lastKnownPosition;
  PermissionStatus permission;
  bool isEnabledLocation = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      checkPermission();
      await _initLastKnownLocation();
      await _initCurrentLocation();
      fetchLocation();
      loading = false;
      setState(() {});
    });
    showPersBottomSheetCallBack = _showBottomSheet;
    sampleData.add(MapTypeModel(1,true, 'assets/style/maptype_nomal.png', 'Nomal', 'assets/style/nomal_mode.json'));
    sampleData.add(MapTypeModel(2,false, 'assets/style/maptype_silver.png', 'Silver', 'assets/style/sliver_mode.json'));
    sampleData.add(MapTypeModel(3,false, 'assets/style/maptype_dark.png', 'Dark', 'assets/style/dark_mode.json'));
    sampleData.add(MapTypeModel(4,false, 'assets/style/maptype_night.png', 'Night', 'assets/style/night_mode.json'));
    sampleData.add(MapTypeModel(5,false, 'assets/style/maptype_netro.png', 'Netro', 'assets/style/netro_mode.json'));
    sampleData.add(MapTypeModel(6,false, 'assets/style/maptype_aubergine.png', 'Aubergine', 'assets/style/aubergine_mode.json'));
  }

  ///Get last known location
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
    } on PlatformException {
      position = null;
    }
    if (!mounted) return;
    _lastKnownPosition = position;
  }

  Future<void> checkPermission() async {
    isEnabledLocation = await Permission.location.serviceStatus.isEnabled;
    if(!isEnabledLocation){
      await Permission.location.request();
    }
  }

  void fetchLocation(){
    checkPermission()?.then((_) {
      if(isEnabledLocation){
        _initCurrentLocation();
      }
    });
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    try{
      await Geolocator.isLocationServiceEnabled();
      currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          _placemark = pos.name + ', ' + pos.thoroughfare;
        });
        widget?.placeBloc?.getCurrentLocation(Place(
            name: _placemark,
            formattedAddress: '',
            lat: currentLocation?.latitude,
            lng: currentLocation?.longitude
        ));
      }
      if(currentLocation != null){
        moveCameraToMyLocation();
      }
    }catch(_){}
  }

  void moveCameraToMyLocation(){
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude,currentLocation?.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  /// Get current location name
  void getLocationName(double lat, double lng) async {
    if(lat != null && lng != null) {
      try{
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks != null && placemarks.isNotEmpty) {
          final Placemark pos = placemarks[0];
            _placemark = pos.name + ', ' + pos.thoroughfare;
          widget?.placeBloc?.getCurrentLocation(Place(
            name: _placemark,
            formattedAddress: '',
            lat: lat,
            lng: lng
          ));
        }
      }catch(_){}
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(currentLocation?.latitude,currentLocation?.longitude);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_96.png'),
    );
    setState(() {
      _markers[markerId] = marker;
    });
    _mapController = controller;
    Future.delayed(Duration(milliseconds: 200), () async {
      _mapController = controller;
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
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

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName){
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }

  void _showBottomSheet() async {
    setState(() {
      showPersBottomSheetCallBack = null;
    });
    _controller = await _scaffoldKey.currentState
        .showBottomSheet((context) {
      return Container(
        height: 300.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Tipo Mapa',style: textStyleHeading18Black,),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.close,color: blackColor,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: sampleData.length,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () {
                        _closeModalBottomSheet();
                        sampleData.forEach((element) => element.isSelected = false);
                        sampleData[index].isSelected = true;
                        changeMapType(sampleData[index].id, sampleData[index].fileName);

                      },
                      child:SelectMapTypeView(sampleData[index]),
                    );
                  },
                ),
              )

            ],
          ),
        )
      );
    });
  }

  void _closeModalBottomSheet() {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final responsive = Responsive(context);
    
    return Scaffold(
        key: _scaffoldKey,
        drawer: MenuScreens(activeScreenName: screenName),
        body: loading ? Center(child: CircularProgressIndicator(),) : Stack(
          children: <Widget>[
            SizedBox(
              //height: MediaQuery.of(context).size.height - 180,
              child: GoogleMap(
                markers: Set<Marker>.of(_markers.values),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation != null ? currentLocation?.latitude : _lastKnownPosition?.latitude ?? 0.0,
                      currentLocation != null ? currentLocation?.longitude : _lastKnownPosition?.longitude ?? 0.0),
                  zoom: 12.0,
                ),
                onCameraMove: (CameraPosition position) {
                  if(_markers.isNotEmpty) {
                    MarkerId markerId = MarkerId(_markerIdVal());
                    Marker marker = _markers[markerId];
                    Marker updatedMarker = marker?.copyWith(
                      positionParam: position?.target,
                    );
                    setState(() {
                      _markers[markerId] = updatedMarker;
                      _position = position;
                    });
                  }
                },
                onCameraIdle: () => getLocationName(
                    // ignore: prefer_if_null_operators
                    _position?.target?.latitude != null ? _position?.target?.latitude : currentLocation?.latitude,
                    // ignore: prefer_if_null_operators
                    _position?.target?.longitude != null ? _position?.target?.longitude : currentLocation?.longitude
                ),
              ),
            ),

            Positioned(
              bottom: 30.0,
              left: 20.0,
              right: 20.0,
              child: Container(
                  height: 230,
                  child: SelectAddress(
                    fromAddress: widget?.placeBloc?.formLocation,
                    toAddress: widget?.placeBloc?.locationSelect,
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchAddressScreen(),
                          fullscreenDialog: true
                      ));
                    },
                  )
              ),
            ),
            Positioned(
                bottom: responsive.hp(36),
                right: 20,
                child: GestureDetector(
                  onTap: (){
                    fetchLocation();
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100.0),),
                    ),
                    child: Icon(Icons.my_location,size: 20.0,color: blackColor,),
                  ),
                )
            ),
            Positioned(
                top: 60,
                right: 10,
                child: GestureDetector(
                  onTap: (){
                    _showBottomSheet();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white
                    ),
                    child: Icon(Icons.layers,color: blackColor,)
                  ),
                )
            ),
            Positioned(
                top: 60,
                left: 10,
                child: GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100.0),),
                    ),
                    child: Icon(Icons.menu, color: blackColor,),
                  ),
                )
            ),
          ],
        ),
    );
  }
}

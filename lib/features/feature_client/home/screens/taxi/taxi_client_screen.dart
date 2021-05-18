import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show cos, sqrt, asin;

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/custom_dropdown_client.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Home/select_map_type.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/models/map_type_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:HTRuta/google_map_helper.dart';


class TaxiClientScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final ClientTaxiPlaceBloc placeBloc;
  TaxiClientScreen({this.placeBloc, this.parentScaffoldKey});
  @override
  _TaxiClientScreenState createState() => _TaxiClientScreenState();
}

class _TaxiClientScreenState extends State<TaxiClientScreen> {
  final String screenName = 'HOME';
  var _scaffoldKey =  GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  DriverFirestoreService driverFirestoreService = DriverFirestoreService();

  CircleId selectedCircle;
  int _markerIdCounter = 0;
  BitmapDescriptor _markerIcon;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  String _placemark = '';
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData =  <MapTypeModel>[];
  PersistentBottomSheetController _controller;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  List<Map<String, dynamic>> listDistance = [{'id': 1, 'title': '500 m', 'unidad': 'M', 'distancia': 500},{'id': 2, 'title': '1 km', 'unidad': 'km', 'distancia': 1},{'id':3,'title': '3 km', 'unidad': 'km', 'distancia': 3},{'id':4,'title': '5 km', 'unidad': 'km', 'distancia': 5}, {'id':5,'title': '15 km', 'unidad': 'km', 'distancia': 15}];
  Map<String, dynamic> distanceOptionSelected = {'id': 1, 'title': '500 m', 'unidad': 'M', 'distancia': 500};
  String selectedDistance = '1';
  bool showing = false;
  Position currentLocation;
  Position _lastKnownPosition;
  PermissionStatus permission;
  bool isEnabledLocation = false;
  bool loading = true;
  double _radius = 500;
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  double distance = 0;
  BitmapDescriptor iconTaxi;
  List<DocumentSnapshot> markersSnapshotList;
  @override
  void initState() {
    super.initState();
    fetchDriverLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await checkPermission();
      await _initLastKnownLocation();
      /* if(_lastKnownPosition != null){
        _initCurrentLocation();
      }else{
        await _initCurrentLocation();
      } */
      iconTaxi = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/taxi_marker.png');
      fetchLocation();
      loading = false;
      if (!mounted) return;
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

  Future<void> fetchDriverLocation() async {
    Query reference = FirebaseFirestore.instance.collection('taxis_in_service').where('available', isEqualTo: true);
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        GeoPoint position = element['posicion'];
        if(position == null) return;
        final MarkerId markerIdDriver = MarkerId(element.id);
        _markers[markerIdDriver] = GMapViewHelper.createMaker(
          markerIdVal: element.id,
          icon: checkPlatform ? 'assets/image/marker/car_top_96.png' : 'assets/image/marker/car_top_48.png',
          lat: position.latitude,
          lng: position.longitude,
        );
        print(element.data());
      });
    });
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
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
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
          _placemark = pos.name + ', ' + pos.thoroughfare;
          print(_placemark);
        widget?.placeBloc?.getCurrentLocation(Place(
          name: _placemark,
          formattedAddress: '',
          lat: lat,
          lng: lng
        ));
      };
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    MarkerId markerId = MarkerId(_markerIdVal());
    Position currentPosition = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
    LatLng position = LatLng(currentPosition.latitude, currentPosition.longitude);
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
    _controller = await _scaffoldKey.currentState.showBottomSheet((context) {
      return  Container(
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
                child:
                GridView.builder(
                  itemCount: sampleData.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return  InkWell(
                      highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () {
                        _closeModalBottomSheet();
                        sampleData.forEach((element) => element.isSelected = false);
                        sampleData[index].isSelected = true;
                        changeMapType(sampleData[index].id, sampleData[index].fileName);
                      },
                      child:  SelectMapTypeView(sampleData[index]),
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
    _controller?.close();
    _controller = null;
  }

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
              label: Text((value['title']), style: TextStyle(color: Colors.white)),
              onSelected: (bool check) {
                setState(() {
                  distanceOptionSelected = listDistance.where((element) => element['id'] == value['id']).toList().first;
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
    if(selectedCircle == '4'){
      setState(() {
        _radius = 5000;
        _moveCamera(12);
      });
    }
    if(selectedCircle == '5'){
      setState(() {
        _radius = 15000;
        _moveCamera(11);
      });
    }
    _addCircle();
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

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
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

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    final responsive = Responsive(context);
    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MenuScreens(activeScreenName: screenName),
        body: loading ? Center(child: CircularProgressIndicator(),) : Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              //height: MediaQuery.of(context).size.height - 180,
              child: GoogleMap(
                circles: Set<Circle>.of(circles.values),
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
                    _position?.target?.latitude ?? currentLocation?.latitude,
                    _position?.target?.longitude ?? currentLocation?.longitude
                ),
              ),
            ),
            // streamMap(),
            // ChangeServiceClientWidget(),
            CustomDropdownClient(),
            Positioned(
              bottom: 30.0,
              left: 20.0,
              right: 20.0,
              child: Column(
                children: [
                  getListOptionDistance(),
                  Container(height: 10),
                  Container(
                      height: 230,
                      child: SelectAddress(
                        fromAddress: widget?.placeBloc?.formLocation,
                        toAddress: widget?.placeBloc?.locationSelect,
                        unidad: distanceOptionSelected['unidad'],
                        distancia: distanceOptionSelected['distancia'],
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchAddressScreen(),
                              fullscreenDialog: true
                          ));
                        },
                      )
                  ),
                ],
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
              top: 50,
              left: 10,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100.0),),
                ),
                child: IconButton(
                  icon: Icon(Icons.menu,size: 20.0,color: blackColor),
                  onPressed: (){
                    final _state = _sideMenuKey.currentState;
                    if (_state.isOpened)
                      _state.closeSideMenu(); // close side menu
                    else
                      _state.openSideMenu();// open side menu
                  }
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

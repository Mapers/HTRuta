import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show cos, sqrt, asin;
import 'dart:typed_data';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/custom_dropdown_client.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/pickupdriver_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:HTRuta/google_map_helper.dart';

class TaxiClientScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final ClientTaxiPlaceBloc placeBloc;
  TaxiClientScreen({this.placeBloc, this.parentScaffoldKey});
  @override
  _TaxiClientScreenState createState() => _TaxiClientScreenState();
}

class _TaxiClientScreenState extends State<TaxiClientScreen> with WidgetsBindingObserver{
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
  Uint8List userPhoto;
  final pickupApi = PickupApi();
  final _prefs = UserPreferences();
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      changeMapType(3, 'assets/style/dark_mode.json');
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchDriverLocation();
    // saveUserPhoto();
    Geolocator.getPositionStream().listen((event) async{
      if(currentLocation == null) return;
      double diferencia = await Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, event.latitude, event.longitude);
      if(mounted && diferencia > 20){
        final MarkerId _markerMy = MarkerId('user_position');
        /* _markers[_markerMy] = GMapViewHelper.createMakerNetwork(
          markerIdVal: 'user_position',
          icon: userPhoto,
          lat: event.latitude,
          lng: event.longitude,
        ); */
        _markers[_markerMy] = MapViewerUtil.generateMarker(
          latLng: LatLng(event.latitude, event.longitude),
          nameMarkerId: 'user_position',
          icon: await MapViewerUtil.getMarkerIcon('https://source.unsplash.com/500x500/?portrait'),
          onTap: ()=>{

          }
        );
        currentLocation = Position(longitude: event.longitude, latitude: event.latitude);
      }
    });
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
      verifyTaxiInService();
    });
  }

  void verifyTaxiInService(){
    bool inService = _prefs.isClientInTaxi;
    if(inService){
      RequestModel data = requestItemFromJson(_prefs.clientTaxiRequest);
      DriverRequest dataDriver = requestDriverItemFromJson(_prefs.clientTaxiDriverRequest);
      final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
      // pedidoProvider.request = Request(id: data.id, iIdUsuario: data.iIdUsuario,dFecReg: '',iTipoViaje: data.iTipoViaje,mPrecio: data.mPrecio,vchDni: data.vchDni,vchCelular: data.vchCelular,vchCorreo: data.vchCorreo,vchLatInicial: data.vchLatInicial,vchLatFinal: data.vchLatFinal,vchLongInicial: data.vchLongInicial,vchLongFinal: data.vchLongFinal,vchNombreInicial: data.vchNombreInicial,vchNombreFinal: data.vchNombreFinal,vchNombres: data.vchNombres,idSolicitud: data.idSolicitud);
      pedidoProvider.request = data;
      pedidoProvider.requestDriver = dataDriver;
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.travelScreen, (route) => true);
    }
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
      if(!mounted) return;
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
  /* void updateOriginPoint() async {
    if(_position == null) return;
    List<Placemark> placemarks = await placemarkFromCoordinates(_position.target.latitude, _position.target.longitude);
    if (placemarks == null || placemarks.isEmpty) return;
    final Placemark newPosition = placemarks[0];
    widget?.placeBloc?.getCurrentLocation(Place(
      name: newPosition.name + ', ' + newPosition.thoroughfare,
      formattedAddress: '',
      lat: _position.target.latitude,
      lng: _position.target.longitude
    ));
    MarkerId markerId = MarkerId('origin');
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(_position.target.latitude, _position.target.longitude),
      draggable: true,
      onDragEnd: (LatLng newPosition){
        print(newPosition);
      },
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_96.png'),
    );
    if(!mounted) return;
    setState(() {
      _markers[markerId] = marker;
    });
  } */
  void updateOriginPointFromCoordinates(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks == null || placemarks.isEmpty) return;
    final Placemark newPosition = placemarks[0];
    widget?.placeBloc?.getCurrentLocation(Place(
      name: newPosition.name + ', ' + newPosition.thoroughfare,
      formattedAddress: '',
      lat: coordinates.latitude,
      lng: coordinates.longitude
    ));
    MarkerId markerId = MarkerId('origin');
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(coordinates.latitude, coordinates.longitude),
      draggable: true,
      onDragEnd: (LatLng newPosition){
        print(newPosition);
      },
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_96.png'),
    );
    if(!mounted) return;
    setState(() {
      _markers[markerId] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    changeMapType(3, 'assets/style/dark_mode.json');
    Position currentPosition = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
    LatLng position = LatLng(currentPosition.latitude, currentPosition.longitude);
    Future.delayed(Duration(milliseconds: 200), () async {
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

  /* void _showBottomSheet() async {
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
  } */

  /* void _closeModalBottomSheet() {
    _controller?.close();
    _controller = null;
  } */

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
          }
        )
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuScreens(activeScreenName: screenName),
      body: loading ? Center(child: CircularProgressIndicator(),) : Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            //height: MediaQuery.of(context).size.height - 180,
            child: GoogleMap(
              circles: Set<Circle>.of(circles.values),
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              onTap: (LatLng newPosition){
                updateOriginPointFromCoordinates(newPosition);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation != null ? currentLocation?.latitude : _lastKnownPosition?.latitude ?? 0.0,
                  currentLocation != null ? currentLocation?.longitude : _lastKnownPosition?.longitude ?? 0.0),
                zoom: 12.0,
              ),
              /* onCameraMove: (CameraPosition position) {
                _position = position;
              },
              onCameraIdle: (){
                updateOriginPoint();
              } */
            ),
          ),
          CustomDropdownClient(),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
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
                    ),
                  ],
                ),
                Container(height: 10),
                getListOptionDistance(),
                Container(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
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
          /* Positioned(
              bottom: 380,
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
          ), */
          // ButtonLayerWidget(parentScaffoldKey: widget.parentScaffoldKey, changeMapType: changeMapType),
          /* Positioned(
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
          ), */
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
    );
  }
}

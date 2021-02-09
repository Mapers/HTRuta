import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:HTRuta/DriverTaxiApp/Api/registro_conductor_api.dart';
import 'package:HTRuta/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/DriverTaxiApp/Screen/Request/requestDetail.dart';
import 'package:HTRuta/DriverTaxiApp/data/Model/mapTypeModel.dart';
import 'package:HTRuta/DriverTaxiApp/data/Model/placeItem.dart';
import 'package:HTRuta/DriverTaxiApp/theme/style.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_router.dart';
import '../../../google_map_helper.dart';
import 'myActivity.dart';
import 'radioSelectMapType.dart';
import '../../Components/itemRequest.dart';
import '../../data/Model/direction_model.dart';
import 'package:flutter/cupertino.dart';


class HomeDriverScreen extends StatefulWidget {
  @override
  _HomeDriverScreenState createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> with TickerProviderStateMixin {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  GoogleMapController _mapController;

  String currentLocationName;
  String newLocationName;
  String _placemark = '';
  GoogleMapController mapController;
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  bool checkPlatform = Platform.isIOS;
  double distance = 0;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = new List<MapTypeModel>();
  PersistentBottomSheetController _controller;
  List<Map<String, dynamic>> listRequest = List<Map<String, dynamic>>();

  List<Routes> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  PolylineId selectedPolyline;
  bool isShowDefault = false;
  Position currentLocation;
  Position _lastKnownPosition;
  bool isEnabledLocation = false;

  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;

  final referenceDatabase = FirebaseDatabase.instance.reference();

  final registroConductorApi = RegistroConductorApi();
  bool isWorking = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await _initLastKnownLocation();
      await _initCurrentLocation();
      fetchLocation();
      fetchEstadoConductor();
      isLoading = false;
      setState(() {
        
      });
    });
    _locationService.getPositionStream().listen((event) async{
      double diferencia = await _locationService.distanceBetween(currentLocation.latitude, currentLocation.longitude, event.latitude, event.longitude);
      if(diferencia > 5){
        final _prefs = PreferenciaUsuario();
        await _prefs.initPrefs();
        final data = await referenceDatabase.child('Coordenada').child(_prefs.idChofer).once();
        if(data.value != null && data.value!= ''){
          referenceDatabase.child('Coordenada').child(_prefs.idChofer).update({
            'latitud' : event.latitude,
            'longitud': event.longitude
          });
        }else{
          referenceDatabase.child('Coordenada').child(_prefs.idChofer).set({
            'idConductor' : _prefs.idChofer,
            'latitud' : event.latitude,
            'longitud': event.longitude
          });
        }
      }
    });
    showPersBottomSheetCallBack = _showBottomSheet;
    sampleData.add(MapTypeModel(1,true, 'assets/style/maptype_nomal.png', 'Nomal', 'assets/style/nomal_mode.json'));
    sampleData.add(MapTypeModel(2,false, 'assets/style/maptype_silver.png', 'Silver', 'assets/style/sliver_mode.json'));
    sampleData.add(MapTypeModel(3,false, 'assets/style/maptype_dark.png', 'Dark', 'assets/style/dark_mode.json'));
    sampleData.add(MapTypeModel(4,false, 'assets/style/maptype_night.png', 'Night', 'assets/style/night_mode.json'));
    sampleData.add(MapTypeModel(5,false, 'assets/style/maptype_netro.png', 'Netro', 'assets/style/netro_mode.json'));
    sampleData.add(MapTypeModel(6,false, 'assets/style/maptype_aubergine.png', 'Aubergine', 'assets/style/aubergine_mode.json'));

    listRequest = [
      {"id": '0',
        "avatar" : "https://source.unsplash.com/1600x900/?portrait",
        "userName" : "Olivia Ramos",
        "date" : '08 Ene 2019 12:00 PM',
        "price" : 150,
        "distance" : "21km",
        "addFrom": "Av. Peru 657",
        "addTo" : "Av. Tupac Amaru 567",
        "locationForm" : LatLng(-8.1034303,-79.0206512),
        "locationTo" : LatLng(-8.0994694,-79.0302491),
      },
      {"id": '1',
        "avatar" : "https://source.unsplash.com/1600x900/?portrait",
        "userName" : "Jordan Diaz",
        "date" : '08 Ene 2019 12:00 PM',
        "price" : 150,
        "distance" : "5km",
        "addFrom": "Av. Juan Pablo II 657",
        "addTo" : "Av. Tupac Amaru 896",
        "locationForm" : LatLng(-8.1183595,-79.0414019),
        "locationTo" : LatLng(-8.0965296,-79.0325108),
      },
      {"id": '2',
        "avatar" : "https://source.unsplash.com/1600x900/?portrait",
        "userName" : "Olivia Ramos",
        "date" : '08 Ene 2019 at 12:00 PM',
        "price" : 152,
        "distance" : "10km",
        "addFrom": "Av. America Nte. 657",
        "addTo" : "Av. Los Incas 345",
        "locationForm" : LatLng(-8.0966565,-79.0198259),
        "locationTo" : LatLng(-8.1159328,-79.0250643),
      },

    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchEstadoConductor() async{
    Dialogs.openLoadingDialog(context);
    final session = Session();
    final data = await session.get();
    final estado = await registroConductorApi.obtenerEstadoChofer(data['dni']);
    Navigator.pop(context);
      if(estado != null){
        if(estado.iEstado == 'Rechazado'){
          Dialogs.confirm(context,title: 'Alerta', message: 'Su solicitud ha sido rechazada totalmente!\n ¿Desea enviar los documentos que se solicitan?'
            ,onConfirm: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
            }
            ,onCancel: (){
              Navigator.pop(context);
            }
          );               
        }
      }

  }

  Future<void> checkPermission() async {
    isEnabledLocation = await Permission.location.serviceStatus.isEnabled;
  }

  void fetchLocation(){
    checkPermission()?.then((_) {
      if(isEnabledLocation){
        _initCurrentLocation();
      }
    });
  }

  ///Get last known location
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator?.getLastKnownPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _lastKnownPosition = position;
    });
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      List<Placemark> placemarks = await _locationService.placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          _placemark = pos.name + ', ' + pos.thoroughfare;
          print(_placemark);
          currentLocationName = _placemark;
        });
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
          zoom: 17.0,
        ),
      ),
    );
  }


  void _onMapCreated(GoogleMapController controller) async {
    this._mapController = controller;
    addMarker(listRequest[0]['locationForm'], listRequest[0]['locationTo']);
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
    print(fileName);
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName).then(_setMapStyle);
    }
  }

  void _showBottomSheet() async {
    setState(() {
      showPersBottomSheetCallBack = null;
    });
    _controller = _scaffoldKey.currentState.showBottomSheet((context) {
      return new Container(
        height: 300.0,
        child: Container(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Tipo de mapa",style: heading18Black,),
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
                new GridView.builder(
                  itemCount: sampleData.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return new InkWell(
                      highlightColor: primaryColor,
                      splashColor: Colors.blueAccent,
                      onTap: () {
                        _closeModalBottomSheet();
                        sampleData.forEach((element) => element.isSelected = false);
                        sampleData[index].isSelected = true;
                        changeMapType(sampleData[index].id, sampleData[index].fileName);

                      },
                      child: new MapTypeItem(sampleData[index]),
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

  addMarker(LatLng locationForm, LatLng locationTo){
    _markers.clear();
    final MarkerId _markerFrom = MarkerId("fromLocation");
    final MarkerId _markerTo = MarkerId("toLocation");
    _markers[_markerFrom] = GMapViewHelper.createMaker(
      markerIdVal: "fromLocation",
      icon: checkPlatform ? "assets/image/marker/gps_point_24.png" : "assets/image/marker/gps_point.png",
      lat: locationForm.latitude,
      lng: locationForm.longitude,
    );

    _markers[_markerTo] = GMapViewHelper.createMaker(
      markerIdVal: "toLocation",
      icon: checkPlatform ? "assets/image/marker/ic_marker_32.png" : "assets/image/marker/ic_marker_128.png",
      lat: locationTo.latitude,
      lng: locationTo.longitude,
    );
    _gMapViewHelper?.cameraMove(fromLocation: locationForm,toLocation: locationTo,mapController: _mapController);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: new MenuDriverScreens(activeScreenName: screenName),
        body: isLoading ? Center(child: CircularProgressIndicator(),) : Container(
            color: whiteColor,
            child: Stack(
              children: <Widget>[
                _buildMapLayer(),
                Positioned(
                  top: 45,
                  left: 110,
                  child: LiteRollingSwitch(
                    textOn: 'Disponible',
                    textOff: 'Ocupado',
                    colorOn: primaryColor,
                    colorOff: Colors.redAccent[700],
                    iconOn: FontAwesomeIcons.digitalOcean,
                    iconOff: FontAwesomeIcons.powerOff,
                    onChanged: (bool state) async{
                      if(state){

                        Dialogs.openLoadingDialog(context);
                        final session = Session();
                        final data = await session.get();
                        final estado = await registroConductorApi.obtenerEstadoChofer(data['dni']);
                        Navigator.pop(context);
                        if(estado != null){
                          if(estado.iEstado == 'Pendiente Aprobación'){
                            Dialogs.alert(context,title: 'Alerta', message: 'Su solicitud aun se encuentra pendiente de aprobación');
                            isWorking = false;
                          }else if(estado.iEstado == 'Rechazado'){
                            Dialogs.confirm(context,title: 'Alerta', message: 'Su solicitud ha sido rechazada totalmente!\n ¿Desea enviar los documentos que se solicitan?'
                              ,onConfirm: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
                              }
                              ,onCancel: (){
                                Navigator.pop(context);
                              }
                            );
                            isWorking = false;
                          }else{
                            isWorking = state;
                          }
                          
                        }else{
                          Dialogs.confirm(context, title: 'Información', message: 'Para comenzar a ganar con Chasqui debe completar su información personal', 
                          onCancel: () { 
                            isWorking = !state;
                            Navigator.pop(context);
                          },
                          onConfirm: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/register_driver');
                          });
                        } 
                      }else{
                        isWorking = state;
                      }
                    },
                    value: isWorking,
                  )
                ),
                Positioned(
                  bottom: isShowDefault == false ? 330 : 250,
                  right: 16,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100.0),),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.my_location,size: 20.0,color: blackColor,),
                      onPressed: (){
                        _initCurrentLocation();
                      },
                    ),
                  )
                ),
                Positioned(
                  top: 50,
                  right: 10,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100.0),),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.layers,size: 20.0,color: blackColor,),
                      onPressed: (){
                        _showBottomSheet();
                      },
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
                        icon: Icon(Icons.menu,size: 20.0,color: blackColor,),
                        onPressed: (){
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: isShowDefault == false ?
                  Container(
                    height: 330,
                    child: TinderSwapCard(
                        orientation: AmassOrientation.TOP,
                        totalNum: listRequest.length,
                        stackNum: 3,
                        maxWidth: MediaQuery.of(context).size.width,
                        minWidth: MediaQuery.of(context).size.width * 0.9,
                        maxHeight: MediaQuery.of(context).size.width * 0.9,
                        minHeight: MediaQuery.of(context).size.width * 0.85,
                        cardBuilder: (context, index) => ItemRequest(
                          avatar: listRequest[index]['avatar'],
                          userName: listRequest[index]['userName'],
                          date: listRequest[index]['date'],
                          price: listRequest[index]['price'].toString(),
                          distance: listRequest[index]['distance'],
                          addFrom: listRequest[index]['addFrom'],
                          addTo: listRequest[index]['addTo'],
                          locationForm: listRequest[index]['locationForm'],
                          locationTo: listRequest[index]['locationTo'],
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetail()));
                          },
                        ),
                        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
                          /// Get swiping card's position
//                          print(details);
                        },
                        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                          /// Get orientation & index of swiped card!
                          print('index $index');
                          print('aaa ${listRequest.length}');
                          setState(() {
                            if(index == listRequest.length-1){
                              setState(() {
                                isShowDefault = true;
                              });
                            }else{
                              addMarker(listRequest[index+1]['locationForm'], listRequest[index+1]['locationTo']);
                            }
                          });
                        }
                      ),
                  ): MyActivity(
                    userImage: 'https://source.unsplash.com/1600x900/?portrait',
                    userName: 'Naomi Cespedes',
                    level: 'Level basico',
                    totalEarned: 'S/.250',
                    hoursOnline: 10.5,
                    totalDistance: '22Km',
                    totalJob: 8,
                  ),
                )
              ],
            ),
        ),
    );
  }

  Widget _buildMapLayer(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _gMapViewHelper.buildMapView(
          context: context,
          onMapCreated: _onMapCreated,
          currentLocation: LatLng(
              currentLocation != null ? currentLocation?.latitude : _lastKnownPosition?.latitude ?? 0.0,
              currentLocation != null ? currentLocation?.longitude : _lastKnownPosition?.longitude ?? 0.0),
          markers: _markers,
          polyLines: _polyLines,
          onTap: (_){
          }
      ),
    );
  }
}

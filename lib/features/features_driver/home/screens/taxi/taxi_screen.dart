import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/push_notification.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/registro_conductor_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/itemRequest.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/myActivity.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Request/requestDetail.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/presentations/widgets/button_layer_widget.dart';
import 'package:HTRuta/features/features_driver/home/presentations/widgets/change_service_driver_widget.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';


class TaxiDriverServiceScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  TaxiDriverServiceScreen({@required this.parentScaffoldKey});

  @override
  _TaxiDriverServiceScreenState createState() => _TaxiDriverServiceScreenState();
}

class _TaxiDriverServiceScreenState extends State<TaxiDriverServiceScreen> with TickerProviderStateMixin {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  GoogleMapController _mapController;

  String currentLocationName;
  String newLocationName;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  List<Map<String, dynamic>> listRequest = [];

  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  bool isShowDefault = false;
  LatLng currentLocation;
  Position _lastKnownPosition;
  bool isEnabledLocation = false;

  final aceptar = '1';
  final rechazar = '2';
  
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;

  final referenceDatabase = FirebaseDatabase.instance.reference();

  final registroConductorApi = RegistroConductorApi();
  bool isWorking = false;
  bool isLoading = true;

  List<Request> requestTaxi = [];
  List<Map> requestPast = [];
  final pickupApi = PickupApi();
  List<String> aceptados = [];
  List<String> rechazados = [];
  PushNotificationProvider pushProvider;
  
  @override
  void initState() {
    super.initState();
    pushProvider = PushNotificationProvider();
    pushProvider.mensajes.listen((argumento) async{
      Map data = argumento['data'];
      if(data == null) return;
      String newRequest = data['newRequest'] ?? '0';
      if (!mounted) return;
      if(newRequest == '1' && isWorking){
        await getSolicitudes();
        analizeChanges(); 
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await _initLastKnownLocation();
      await _initCurrentLocation();
      fetchLocation();
      fetchEstadoConductor();
      isLoading = false; 
      setState(() {});
      final _prefs = UserPreferences();
      await _prefs.initPrefs();
      await getSolicitudes();
      requestPast = requestTaxi.map((e) => {
        'id': e.id,
        'precio': e.mPrecio 
      }).toList();
      setState(() {});
    });
  }
  Future<void> getSolicitudes() async {
      final _prefs = UserPreferences();
      LocationEntity locationEntity = await LocationUtil.currentLocation();
      final data = await pickupApi.getRequest(_prefs.idChofer, locationEntity.latLang.latitude.toString(),locationEntity.latLang.longitude.toString());
      print(_prefs.idChofer);
      if(data != null){
        requestTaxi.clear();
        aceptados.clear();
        rechazados.clear();
        requestTaxi.addAll(data);
        requestTaxi.reversed;
        var removeData = [];

        requestTaxi.forEach((data) {
          if(data.aceptados != null){
            aceptados = data.aceptados.split(',');
            aceptados.forEach((element) {
              if(element == _prefs.idChofer){
                removeData.add(data);
              }
            });
          }
        });
        requestTaxi.removeWhere((element) => removeData.contains(element));

        removeData.clear();

        requestTaxi.forEach((data) {
          if(data.rechazados != null){
            rechazados = data.rechazados.split(',');
            rechazados.forEach((element) {
              if(element == _prefs.idChofer){
                removeData.add(data);
              }
            });
          }
        });
        requestTaxi.removeWhere((element) => removeData.contains(element));
      }
  }
  void analizeChanges(){
    if(requestTaxi.length == requestPast.length){
      requestTaxi?.forEach((element1) => {
        requestPast?.forEach((element2) {
          if(element1.id == element2['id']){
            if(element1.mPrecio != element2['precio']){
              double precioAnt = double.parse(element2['precio']);
              double precioAct = double.parse(element1.mPrecio);
              double diff = precioAct - precioAnt;
              if(diff > 0){
                Fluttertoast.showToast(
                  msg: '${element1.vchNombres} aumentó la puja en $diff soles',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
                );
              }else if (diff < 0){ 
                Fluttertoast.showToast(
                  msg: '${element1.vchNombres} disminuyó la puja en $diff soles',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              }
            }
          }  
        })
      });
    }
    if(requestTaxi.length < requestPast.length){
      Fluttertoast.showToast(
        msg: 'Se canceló una solicitud de viaje',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      ); 
    }
    
    if(requestTaxi.length > requestPast.length){
      Fluttertoast.showToast(
          msg: 'Tienes una nueva solicitud de viaje',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      ); 
    }
    requestPast = requestTaxi.map((e) => {
      'id': e.id,
      'precio': e.mPrecio 
    }).toList();
    if (!mounted) return;
    setState(() {});  
  }
  Future<void> fetchEstadoConductor() async{
    Dialogs.openLoadingDialog(context);
    final session = Session();
    final data = await session.get();
    final estado = await registroConductorApi.obtenerEstadoChofer(data.dni);
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
    LocationEntity locationEntity = await LocationUtil.currentLocation();
    setState(() {
      currentLocation = locationEntity.latLang;
      currentLocationName = locationEntity.streetName;
    });
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
    _mapController = controller;
    if(listRequest.isNotEmpty){
      addMarker(listRequest.first['locationForm'], listRequest.first['locationTo']);
    }
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

  void addMarker(LatLng locationForm, LatLng locationTo){
    _markers.clear();
    final MarkerId _markerFrom = MarkerId('fromLocation');
    final MarkerId _markerTo = MarkerId('toLocation');
    _markers[_markerFrom] = GMapViewHelper.createMaker(
      markerIdVal: 'fromLocation',
      icon: checkPlatform ? 'assets/image/marker/gps_point_24.png' : 'assets/image/marker/gps_point.png',
      lat: locationForm.latitude,
      lng: locationForm.longitude,
    );

    _markers[_markerTo] = GMapViewHelper.createMaker(
      markerIdVal: 'toLocation',
      icon: checkPlatform ? 'assets/image/marker/ic_marker_32.png' : 'assets/image/marker/ic_marker_128.png',
      lat: locationTo.latitude,
      lng: locationTo.longitude,
    );
    _gMapViewHelper?.cameraMove(fromLocation: locationForm, toLocation: locationTo, mapController: _mapController);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> bodyContent = [
      _buildMapLayer(),
      ChangeServiceDriverWidget(),
      Positioned(
        top: 110,
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
              final estado = await registroConductorApi.obtenerEstadoChofer(data.dni);
              Navigator.pop(context);
              if(estado != null){
                if(estado.iEstado == 'Pendiente Aprobación'){
                  Dialogs.alert(context,title: 'Alerta', message: 'Su solicitud aun se encuentra pendiente de aprobación');
                  isWorking = false;
                }else if(estado.iEstado == 'Rechazado'){
                  Dialogs.confirm(context,title: 'Alerta', message: 'Su solicitud ha sido rechazada totalmente!\n ¿Desea enviar los documentos que se solicitan?',
                    onConfirm: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
                    },
                    onCancel: (){
                      Navigator.pop(context);
                    }
                  );
                  isWorking = false;
                }else{
                  DriverFirestoreService driverFirestoreService = DriverFirestoreService();
                  final _prefs = UserPreferences();
                  String token = _prefs.tokenPush;
                  String id = _prefs.idChofer;
                  driverFirestoreService.setDriverData(token, id, 'Aprobado');
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
              DriverFirestoreService driverFirestoreService = DriverFirestoreService();
              final _prefs = UserPreferences();
              String id = _prefs.idChofer;
              driverFirestoreService.updateDriverAvalability(false, id);
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
            onPressed: () => _initCurrentLocation(),
          ),
        )
      ),
      ButtonLayerWidget(parentScaffoldKey: widget.parentScaffoldKey, changeMapType: changeMapType),
      Align(
        alignment: Alignment.bottomCenter,
        child: isShowDefault == false ?
        Container(
          height: 330,
          child: TinderSwapCard(
              orientation: AmassOrientation.TOP,
              totalNum: requestTaxi.length,
              stackNum: 3,
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 0.9,
              minHeight: MediaQuery.of(context).size.width * 0.85,
              cardBuilder: (context, index) => InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetail(requestItem: requestTaxi[index])));
                },
                child: ItemRequest(
                  avatar: 'https://source.unsplash.com/1600x900/?portrait',
                  userName: requestTaxi[index].vchNombres,
                  date: requestTaxi[index].dFecReg,
                  price: requestTaxi[index].mPrecio,
                  distance: '',
                  addFrom: requestTaxi[index].vchNombreInicial,
                  addTo: requestTaxi[index].vchNombreFinal,
                  locationForm: LatLng(
                    double.parse(requestTaxi[index].vchLatInicial),
                    double.parse(requestTaxi[index].vchLongInicial),
                  ),
                  locationTo: LatLng(
                    double.parse(requestTaxi[index].vchLatFinal),
                    double.parse(requestTaxi[index].vchLongFinal),
                  ),
                  onTap: () async {
                    print('Aceptar');
                    try{
                      final _prefs = UserPreferences();
                      await _prefs.initPrefs();
                      Dialogs.openLoadingDialog(context);
                      final dato = await pickupApi.actionTravel(
                        _prefs.idChofer,
                        requestTaxi[index].id,
                        double.parse(requestTaxi[index].vchLatInicial),
                        double.parse(requestTaxi[index].vchLatFinal),
                        double.parse(requestTaxi[index].vchLongInicial),
                        double.parse(requestTaxi[index].vchLongFinal),
                        '',
                        double.parse(requestTaxi[index].mPrecio),
                        requestTaxi[index].iTipoViaje,
                        '', '', '',
                        requestTaxi[index].vchNombreInicial,
                        requestTaxi[index].vchNombreFinal,
                        aceptar
                      );
                      PushMessage pushMessage = PushMessage();
                      Map<String, String> data = {
                        'newOffer' : '1'
                      };
                      pushMessage.sendPushMessage(token: requestTaxi[index].token, title: 'Oferta de conductor', description: 'Nueva oferta de conductor', data: data);
                      Navigator.pop(context);
                      if(dato){
                        //Esperar solicitud
                      }else{
                        Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
                      }
                    }on ServerException catch(e){
                      Navigator.pop(context);
                      Dialogs.alert(context,title: 'Error', message: e.message);
                    }
                  },
                ),
              ),
              swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
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
          totalEarned: 'S/. 250.00',
          hoursOnline: 10.5,
          totalDistance: '22Km',
          totalJob: 8,
        ),
      )
    ];

    return isLoading ? Center(child: CircularProgressIndicator(),) : Container(
      color: whiteColor,
      child: Stack(
        children: bodyContent,
        alignment: Alignment.center,
      )
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
          currentLocation != null ? currentLocation?.longitude : _lastKnownPosition?.longitude ?? 0.0
        ),
        markers: _markers,
        polyLines: _polyLines,
        onTap: (_){
        }
      ),
    );
  }
}

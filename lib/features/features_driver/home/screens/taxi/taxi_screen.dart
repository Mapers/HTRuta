import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/core/push_message/push_notification.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/registro_conductor_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/itemRequest.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/myActivity.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/travelDriver_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Request/requestDetail.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/custom_dropdown_driver.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';


class TaxiDriverServiceScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  TaxiDriverServiceScreen({@required this.parentScaffoldKey});

  @override
  _TaxiDriverServiceScreenState createState() => _TaxiDriverServiceScreenState();
}

class _TaxiDriverServiceScreenState extends State<TaxiDriverServiceScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
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
  DriverFirestoreService driverFirestoreService = DriverFirestoreService();
  List<String> acceptedTravels = [];

  final aceptar = '1';
  final rechazar = '2';
  
  PermissionStatus permission;

  final registroConductorApi = RegistroConductorApi();
  bool isWorking = true;
  bool isLoading = true;
  bool waitingForResponse = false;

  List<RequestModel> requestTaxi = [];
  List<Map> requestPast = [];
  final pickupApi = PickupApi();
  List<String> aceptados = [];
  List<String> rechazados = [];
  PushNotificationProvider pushProvider;
  final _prefs = UserPreferences();
  String lastUserToken;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // changeMapType(3, 'assets/style/dark_mode.json');
      _mapController.setMapStyle(null);
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isWorking = _prefs.drivingState;
    pushProvider = PushNotificationProvider();
    pushProvider.mensajes.listen((argumento) async{
      Map data = argumento['data'];
      if(data == null) return;
      String newRequest = data['newRequest'] ?? '0';
      String newCancelSol = data['newCancelSol'] ?? '0';
      String newConfirm = data['newConfirm'] ?? '0';
      String idSolicitud = data['idSolicitud'] ?? '0';
      if (!mounted) return;
      if(newRequest == '1' && isWorking){
        final _prefs = UserPreferences();
        _prefs.setNotificacionConductor = 'Solicitudes,Tiene una nueva solicitud';
        await getSolicitudes();
        analizeChanges(); 
      }
      if(newCancelSol == '1' && isWorking){
        final _prefs = UserPreferences();
        _prefs.setNotificacionConductor = 'Solicitudes,El usuario canceló la solicitud';
        if(mounted){
          waitingForResponse = false;
          setState(() {});
        }
        await getSolicitudes();
        analizeChanges(); 
      }
      if(newConfirm == '1'&& isWorking){
        final _prefs = UserPreferences();
        _prefs.setNotificacionConductor = 'Viajes,Haz iniciado un nuevo viaje';
        if(mounted){
          waitingForResponse = false;
          setState(() {});
        }
        await travelConfirmation(idSolicitud);
      }
    });
    Geolocator.getPositionStream(distanceFilter: 15).listen((event) async{
      if(currentLocation == null) return;
      double diferencia = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, event.latitude, event.longitude);
      if(diferencia > 10 && isWorking && mounted){
        /* _markers.clear();
        if(mounted){
          setState(() {});
        }
        await Future.delayed(Duration(milliseconds: 250));
        Marker marker = GMapViewHelper.createMaker(
          markerIdVal: 'myPosition',
          icon: 'assets/image/marker/taxi_marker.png',
          lat: event.latitude,
          lng: event.longitude,
        );
        if(mounted){
          setState(() {
            _markers[marker.markerId] = marker;
          });
        } */
        await driverFirestoreService.updateDriverPosition(currentLocation.latitude, currentLocation.longitude, _prefs.idChofer);
      }
      currentLocation = LatLng(event.latitude, event.longitude);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      
      await _initLastKnownLocation();
      await _initCurrentLocation().catchError((e) => {
        debugPrint(e.toString())
      });
      fetchLocation();
      // fetchEstadoConductor();
      fetchDataImportante();
      isLoading = false;
      if (!mounted) return;
      setState(() {});
      final _prefs = UserPreferences();
      await _prefs.initPrefs();
      // readDrivingState();
      await getSolicitudes();
      requestPast = requestTaxi.map((e) => {
        'id': e.id,
        'precio': e.mPrecio 
      }).toList();
      if (!mounted) return;
      setState(() {});
      verifyTaxiInService();
    });
  }
  void verifyTaxiInService() async {
    bool inService = _prefs.isDriverInService;
    if(inService){
      RequestModel data = requestItemFromJson(_prefs.taxiRequestInCourse);
      final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
      // pedidoProvider.request = Request(id: data.id, iIdUsuario: data.iIdUsuario,dFecReg: '',iTipoViaje: data.iTipoViaje,mPrecio: data.mPrecio,vchDni: data.vchDni,vchCelular: data.vchCelular,vchCorreo: data.vchCorreo,vchLatInicial: data.vchLatInicial,vchLatFinal: data.vchLatFinal,vchLongInicial: data.vchLongInicial,vchLongFinal: data.vchLongFinal,vchNombreInicial: data.vchNombreInicial,vchNombreFinal: data.vchNombreFinal,vchNombres: data.vchNombres,idSolicitud: data.idSolicitud);
      pedidoProvider.request = data;
      if(currentLocation == null){
        final position = await Geolocator.getCurrentPosition();
        currentLocation = LatLng(position.latitude, position.longitude);
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TravelDriverScreen(currentLocation)), (route) => false);
    }
  }
  Future<void> travelConfirmation(String idSolicitud) async {
    final _prefs = UserPreferences();
    final data = await pickupApi.solicitudesUsuarioChofer(idSolicitud, _prefs.idChofer);
    _prefs.taxiRequestInCourse = requestItemToJson(data);
    _prefs.isDriverInService = true;
    final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
    pedidoProvider.request = data;
    if(currentLocation == null){
      final position = await Geolocator.getCurrentPosition();
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TravelDriverScreen(currentLocation)), (route) => false);
  }
  Future<void> getSolicitudes() async {
    final _prefs = UserPreferences();
    LocationEntity locationEntity = await LocationUtil.currentLocation();
    final data = await pickupApi.getRequest(_prefs.idChoferReal, locationEntity.latLang.latitude.toString(),locationEntity.latLang.longitude.toString());
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
    }else{
      requestTaxi.clear();
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
      vibrateNewRequest();
    }
    requestPast = requestTaxi.map((e) => {
      'id': e.id,
      'precio': e.mPrecio 
    }).toList();
    if (!mounted) return;
    setState(() {});  
  }
  Future<void> vibrateNewRequest() async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500, 1000, 500, 1000]);
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      Vibration.vibrate(duration: 1000);
      await Future.delayed(Duration(milliseconds: 500));
      Vibration.vibrate(duration: 1000);
      await Future.delayed(Duration(milliseconds: 500));
      Vibration.vibrate(duration: 1000);
    }
  }
  Future<void> fetchEstadoConductor() async{
    Dialogs.openLoadingDialog(context);
    final session = Session();
    final data = await session.get();
    final estado = await registroConductorApi.obtenerEstadoChofer(data.dni);
    Navigator.pop(context);
    if(estado != null){
      if(estado.iEstado == 'Rechazado'){
        Dialogs.confirm(context,title: 'Alerta', message: 'Su solicitud ha sido rechazada!\n ¿Desea enviar los documentos que se solicitan?'
          ,onConfirm: (){
            Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
          }
          ,onCancel: (){
            Navigator.pop(context);
          }
        );
      }
    }
  }
  Future<void> fetchDataImportante() async{
    final session = Session();
    final data = await session.getDriverData();
    if(data.saldo == 0 && data.metodosPago == 'false'){
      Dialogs.confirm(context,title: 'Alerta', message: 'Recargue su saldo y guarde sus métodos de pago para recibir viajes'
        ,onConfirm: (){
        }
      );
    }else if (data.saldo == 0){
      Dialogs.confirm(context,title: 'Alerta', message: 'Recargue su saldo para recibir viajes'
        ,onConfirm: (){
        }
      );
    }else if (data.metodosPago == 'false'){
      Dialogs.confirm(context,title: 'Alerta', message: 'Guarde sus métodos de pago para recibir viajes'
        ,onConfirm: (){
        }
      );
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
      position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
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
    if (!mounted) return;
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
    // changeMapType(3, 'assets/style/dark_mode.json');
    /* final MarkerId _markerMy = MarkerId('toLocation');
    if(currentLocation != null){
      _markers[_markerMy] = GMapViewHelper.createMaker(
        markerIdVal: 'fromLocation',
        icon: 'assets/image/marker/taxi_marker.png',
        lat: currentLocation.latitude,
        lng: currentLocation.longitude,
      );
    } */
    if(listRequest.isNotEmpty){
      addMarker(listRequest.first['locationForm'], listRequest.first['locationTo']);
    }
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    if (!mounted) return;
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName){
    if (fileName == null) {
      if (!mounted) return;
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
      icon: checkPlatform ? 'assets/image/marker/car_top_96.png' : 'assets/image/marker/car_top_48.png',
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
      CustomDropdownDriver(),
      
      Positioned(
        top: 110,
        child: FlutterSwitch(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 55.0,
          valueFontSize: 18.0,
          toggleSize: 45.0,
          value: isWorking,
          borderRadius: 30.0,
          inactiveText: 'Ocupado',
          activeText: 'Disponible',
          activeTextFontWeight: FontWeight.normal,
          inactiveTextFontWeight: FontWeight.normal,
          activeColor: primaryColor,
          activeIcon: Icon(FontAwesomeIcons.digitalOcean),
          inactiveIcon: Icon(FontAwesomeIcons.powerOff),
          inactiveColor: Colors.red,
          padding: 8.0,
          showOnOff: true,
          onToggle:  (state) async {
            setState(() {
              isWorking = !isWorking;
            });
            if(state){
              Dialogs.openLoadingDialog(context);
              final session = Session();
              final data = await session.get();
              final estado = await registroConductorApi.obtenerEstadoChofer(data.dni);
              Navigator.pop(context);
              if(estado != null){
                if(estado.iEstado == 'Pendiente Aprobación'){
                  Dialogs.alert(context,title: 'Alerta', message: 'Su solicitud aun se encuentra pendiente de aprobación');
                  final _prefs = UserPreferences();
                  _prefs.setDrivingState = false;
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
                  final _prefs = UserPreferences();
                  _prefs.setDrivingState = false;
                  isWorking = false;
                }else{
                  final _prefs = UserPreferences();
                  String token = _prefs.tokenPush;
                  String id = _prefs.idChofer;
                  driverFirestoreService.setDriverData(token, id, 'Aprobado', currentLocation != null ? currentLocation.latitude : 0, currentLocation != null ? currentLocation.longitude: 0);
                  _prefs.setDrivingState = state;
                  isWorking = state;
                }
              }else{
                Dialogs.confirm(context, title: 'Información', message: 'Para comenzar a ganar con Chasqui debe completar su información personal', 
                onCancel: () { 
                  isWorking = !state;
                  final _prefs = UserPreferences();
                  _prefs.setDrivingState = false;
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
              _prefs.setDrivingState = state;
              String id = _prefs.idChofer;
              driverFirestoreService.updateDriverAvalability(false, id);
              isWorking = state;
            }
          },
        ),
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
      // ButtonLayerWidget(parentScaffoldKey: widget.parentScaffoldKey, changeMapType: changeMapType),
      requestTaxi.isNotEmpty && !waitingForResponse ? Align(
        alignment: Alignment.bottomCenter,
        child: isShowDefault == false ?
        Container(
          height: MediaQuery.of(context).size.width,
          child: TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: requestTaxi.length,
            stackNum: 3,
            maxWidth: MediaQuery.of(context).size.width,
            minWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 1.4,
            minHeight: MediaQuery.of(context).size.width * 0.85,
            cardBuilder: (context, index) => InkWell(
              onTap: () async {
                String newPrice = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetail(requestItem: requestTaxi[index], driverLocation: currentLocation)));
                if(newPrice != null){
                  try{
                    Dialogs.openLoadingDialog(context);
                    final dato = await pickupApi.actionTravel(
                      _prefs.idChofer,
                      requestTaxi[index].id,
                      double.parse(requestTaxi[index].vchLatInicial),
                      double.parse(requestTaxi[index].vchLatFinal),
                      double.parse(requestTaxi[index].vchLongInicial),
                      double.parse(requestTaxi[index].vchLongFinal),
                      '',
                      double.parse(newPrice),
                      requestTaxi[index].iTipoViaje,
                      '', '', '',
                      requestTaxi[index].vchNombreInicial,
                      requestTaxi[index].vchNombreFinal,
                      aceptar,
                      _prefs.tokenPush
                    );
                    PushMessage pushMessage = getIt<PushMessage>();
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
                }
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
                onPriceUpdate: (String newPrice){
                  requestTaxi[index].mPrecio = newPrice;
                  setState(() {});
                },
                onAccept: () async {
                  try{
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
                      aceptar,
                      _prefs.tokenPush
                    );
                    if(!dato){
                      Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
                      return;
                    }
                    acceptedTravels.add(requestTaxi[index].id);
                    lastUserToken = requestTaxi[index].token;
                    PushMessage pushMessage = getIt<PushMessage>();
                    Map<String, String> data = {
                      'newOffer' : '1'
                    };
                    pushMessage.sendPushMessage(token: requestTaxi[index].token, title: 'Oferta de conductor', description: 'Nueva oferta de conductor', data: data);
                    Navigator.pop(context);
                    if(mounted){
                      waitingForResponse = true;
                      setState(() {});
                    }
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
                onRefuse: () async {
                try{
                  Dialogs.openLoadingDialog(context);
                  final dato = await pickupApi.actionTravel(
                    _prefs.idChofer,
                    requestTaxi[index].id,
                    double.parse(requestTaxi[index].vchLatInicial),
                    double.parse(requestTaxi[index].vchLatFinal),
                    double.parse(requestTaxi[index].vchLongInicial),
                    double.parse(requestTaxi[index].vchLongInicial),
                    '',
                    double.parse(requestTaxi[index].mPrecio),
                    requestTaxi[index].iTipoViaje,
                      '', '','',
                    requestTaxi[index].vchNombreInicial,
                    requestTaxi[index].vchNombreFinal,
                    rechazar,
                    _prefs.tokenPush
                  );
                  if(!dato){
                    Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
                    return;
                  }
                  if(acceptedTravels.contains(requestTaxi[index].id)){
                    PushMessage pushMessage = getIt<PushMessage>();
                    Map<String, String> data = {
                      'newReffuse' : '1',
                      'idChofer': _prefs.idChoferReal
                    };
                    lastUserToken = requestTaxi[index].token;
                    pushMessage.sendPushMessage(token: requestTaxi[index].token, title: 'Cancelación de oferta', description: 'El conductor canceló la oferta', data: data);
                  }
                  await getSolicitudes();
                  analizeChanges();
                  Navigator.pop(context);
                  
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
              if(orientation.index == 0){
                cancelTravel(requestTaxi[index]);
              }else{
                acceptTravel(requestTaxi[index]);
              }
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
      ) : Container(),
      waitingForResponse ? Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: primaryColor.withOpacity(0.6)
      ) : Container(),
      waitingForResponse ? Positioned(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                width: 40,
                height: 40,
                child: CircularProgressIndicator()
              )
            ),
            Text('Esperando\nconfirmación', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54))
          ],
        )
      ) : Container(),
    ];

    return isLoading ? Center(child: CircularProgressIndicator(),) : Container(
      color: whiteColor,
      child: Stack(
        children: bodyContent,
        alignment: Alignment.center,
      )
    );
  }
  void acceptTravel(RequestModel request) async {
    try{
      Dialogs.openLoadingDialog(context);
      final dato = await pickupApi.actionTravel(
        _prefs.idChofer,
        request.id,
        double.parse(request.vchLatInicial),
        double.parse(request.vchLatFinal),
        double.parse(request.vchLongInicial),
        double.parse(request.vchLongFinal),
        '',
        double.parse(request.mPrecio),
        request.iTipoViaje,
        '', '', '',
        request.vchNombreInicial,
        request.vchNombreFinal,
        aceptar,
        _prefs.tokenPush
      );
      if(!dato){
        Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
        return;
      }
      PushMessage pushMessage = getIt<PushMessage>();
      Map<String, String> data = {
        'newOffer' : '1'
      };
      pushMessage.sendPushMessage(token: request.token, title: 'Oferta de conductor', description: 'Nueva oferta de conductor', data: data);
      Navigator.pop(context);
      if(mounted){
        waitingForResponse = true;
        setState(() {});
      }
    }on ServerException catch(e){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: e.message);
    }
  }
  void cancelTravel(RequestModel request) async {
    try{
      Dialogs.openLoadingDialog(context);
      final dato = await pickupApi.actionTravel(
        _prefs.idChofer,
        request.id,
        double.parse(request.vchLatInicial),
        double.parse(request.vchLatFinal),
        double.parse(request.vchLongInicial),
        double.parse(request.vchLongInicial),
        '',
        double.parse(request.mPrecio),
        request.iTipoViaje,
          '', '','',
        request.vchNombreInicial,
        request.vchNombreFinal,
        rechazar,
        _prefs.tokenPush
      );
      await getSolicitudes();
      analizeChanges();
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
        myLocationEnabled: true,
      ),
    );
  }
}

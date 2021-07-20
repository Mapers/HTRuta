import 'dart:async';
import 'dart:io' show Platform;

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/core/push_message/push_notification.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/comment_user_dialog.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:HTRuta/models/map_type_model.dart';
import 'package:HTRuta/core/map_network/map_network.dart';
import 'package:HTRuta/models/minutes_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:HTRuta/models/direction_model.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:HTRuta/app/navigation/routes.dart';

class TravelScreen extends StatefulWidget {
  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> with WidgetsBindingObserver {
  final String screenName = 'HOME';
  var _scaffoldKey =GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  int _markerIdCounter = 0;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = [];

  Position currentLocation;
  Position _lastKnownPosition;
  PermissionStatus permission;
  bool isEnabledLocation = false;

  int _polylineIdCounter = 1;
  String distance, duration;
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  var apis = MapNetwork();
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  List<RoutesDirectionModel> routesData;
  bool travelInits = false;
  final pickupApi = PickupApi();
  final referenceDatabase = FirebaseDatabase.instance.reference();
  PushNotificationProvider pushProvider;
  final _prefs = UserPreferences();
  GeoPoint driverPosition;
  Timer timer;
  AproxElement aproxElement;
  bool appInBackground = false;
  bool notificationListenerExecuted = false;
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    if (state == AppLifecycleState.resumed) {
      changeMapType(3, 'assets/style/dark_mode.json');
      if(!notificationListenerExecuted){
        appInBackground = false;
        updateStateWhenNoNotificationSelected(context);
      }
      appInBackground = false;
    }
    if (state == AppLifecycleState.paused) {
      appInBackground = true;
      //Escribir en los shared preferences
    }
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fechDriverLocation();
    pushProvider = PushNotificationProvider();
    pushProvider.mensajes.listen((argumento) async{
      if(appInBackground){
        notificationListenerExecuted = true;
        appInBackground = false;
      }
      Map data = argumento['data'];
      if(data == null) return;
      String newCancel = data['newCancel'] ?? '0';
      String idSolicitud = data['idSolicitud'] ?? '0';
      String travelInit = data['travelInit'] ?? '0';
      String travelFinish = data['travelFinish'] ?? '0';
      if (!mounted) return;
      if(newCancel == '1'){
        final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
        if(idSolicitud == pedidoProvider.request.id){
          _prefs.setNotificacionUsuario = 'Viajes,El conductor canceló el viaje';
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
        _prefs.isClientInTaxi = false;
        timer?.cancel();
        Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
      }
      if(travelInit == '1'){
        travelInits = true;
        timer?.cancel();
        _prefs.setNotificacionUsuario = 'Viajes,Su viaje ha iniciado';
        await getRouter();
        addMakers();
      }
      if(travelFinish == '1'){
        _prefs.setNotificacionUsuario = 'Viajes,Su viaje ha finalizado';
        final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
        if(idSolicitud == pedidoProvider.request.id){
          await showDialog(
            context: context,
            barrierDismissible: false,
            child: CommentUserDialog()
          );
          Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
        }
      }
    });
    timer = Timer.periodic(Duration(seconds: 10), (Timer t){
        updateTimeAproximation(context);
        if(!mounted) return;
        setState(() {});
      }
    );
  }
  Future<void> updateStateWhenNoNotificationSelected(BuildContext context) async{
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
    try{
      final item = await pickupApi.getHistoryDriverDetail(pedidoProvider.idViaje);
      if(item.estado == '5'){
        travelInits = true;
        timer?.cancel();
        _prefs.setNotificacionUsuario = 'Viajes,Su viaje ha iniciado';
        await getRouter();
        addMakers();
      }else if (item.estado == '6'){
        _prefs.setNotificacionUsuario = 'Viajes,Su viaje ha finalizado';
        await showDialog(
          context: context,
          barrierDismissible: false,
          child: CommentUserDialog()
        );
        Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
      }
    }catch(e){
      print(e);
    }
  }
  Future<void> updateTimeAproximation(BuildContext context) async {
    if(driverPosition == null) return;
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
    try{
      aproxElement = await pickupApi.calculateMinutes(driverPosition.latitude, driverPosition.longitude, double.parse(pedidoProvider.request.vchLatInicial), double.parse(pedidoProvider.request.vchLongInicial));
    }catch(e){
      return;
    }
    if(!mounted) return;
    setState(() {});
  }
  Future<void> getRouter() async {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
    polyLines.clear();
    var router;
    LatLng _fromLocation = LatLng(double.parse(pedidoProvider.request.vchLatInicial), double.parse(pedidoProvider.request.vchLongInicial));
    LatLng _toLocation = LatLng(double.parse(pedidoProvider.request.vchLatFinal), double.parse(pedidoProvider.request.vchLongFinal));
    bool routeFound = true;
    await apis.getRoutes(
      getRoutesRequest: GetRoutesRequestModel(
        fromLocation: _fromLocation,
        toLocation: _toLocation,
        mode: 'DRIVING'
      ),
    ).then((data) {
      if (data != null) {
        if(data.result.routes.isEmpty){
          routeFound = false;
        }else{
          router = data?.result?.routes[0]?.overviewPolyline?.points;
          routesData = data?.result?.routes;
        }
      }
    }).catchError((_) {});
    if(!routeFound) {
      _gMapViewHelper.cameraMove(fromLocation: _fromLocation,toLocation: _toLocation,mapController: _mapController);
      return;
    }
    distance = routesData[0]?.legs[0]?.distance?.text;
    duration = routesData[0]?.legs[0]?.duration?.text;

    polyLines[polylineId] = GMapViewHelper.createPolyline(
      polylineIdVal: polylineIdVal,
      router: router
    );
    setState(() {});
    _gMapViewHelper.cameraMove(fromLocation: _fromLocation,toLocation: _toLocation,mapController: _mapController);
  }
  void addMakers(){
    final MarkerId markerIdFrom = MarkerId('from_address');
    final MarkerId markerIdTo = MarkerId('to_address');
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);

    final Marker marker = Marker(
      markerId: markerIdFrom,
      position: LatLng(double.parse(pedidoProvider.request.vchLatInicial), double.parse(pedidoProvider.request.vchLongInicial)),
      infoWindow: InfoWindow(title: 'Recojo', snippet: pedidoProvider.request.vchNombreInicial),
      // ignore: deprecated_member_use
      icon:  checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_96.png'),
      onTap: () {
      },
    );

    final Marker markerTo = Marker(
      markerId: markerIdTo,
      position: LatLng(double.parse(pedidoProvider.request.vchLatFinal), double.parse(pedidoProvider.request.vchLongFinal)),
      infoWindow: InfoWindow(title: 'Dejar', snippet: pedidoProvider.request.vchNombreFinal),
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png'),
      onTap: () {
      },
    );

    setState(() {
      _markers[markerIdFrom] = marker;
      _markers[markerIdTo] = markerTo;
    });
  }
  Future<void> fechDriverLocation() async {
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
    DocumentReference reference = FirebaseFirestore.instance.collection('taxis_in_service').doc(pedidoProvider.requestDriver.iIdUsuario);
    reference.snapshots().listen((querySnapshot) {
      GeoPoint position = querySnapshot['posicion'];
      if(position == null) return;
      driverPosition = position;
      final MarkerId markerIdDriver = MarkerId(querySnapshot.id);
      _markers[markerIdDriver] = GMapViewHelper.createMaker(
        markerIdVal: querySnapshot.id,
        icon: checkPlatform ? 'assets/image/marker/car_top_96.png' : 'assets/image/marker/car_top_48.png',
        lat: position.latitude,
        lng: position.longitude,
      );
    });
  }
  /* Future<void> fechDriverLocation() async {
    final provider = Provider.of<PedidoProvider>(context,listen: false);
    referenceDatabase.child('Coordenada').onValue.listen((event) {
      print('Data: ${event.snapshot.value}');
      var dataFirebase = Map<String,dynamic>.from(event.snapshot.value);
      dataFirebase.forEach((key, value) {
        if(key == '${provider.requestDriver.iIdUsuario}'){
          // posicionChofer = coordenadaFromJson(value);
          posicionChofer = value;
          MarkerId markerId = MarkerId(provider.requestDriver.iIdUsuario);
          LatLng position = LatLng(value['latitud'], value['longitud']);
          Marker marker = Marker(
            markerId: markerId,
            position: position,
            draggable: false,
            // ignore: deprecated_member_use
            icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/car_top_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/car_top_96.png'),
          );
          setState(() {
            _markers[markerId] = marker;
          });
        }
      });
    });
  } */

  ///Get last known location
  // ignore: unused_element
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {return;}
    _lastKnownPosition = position;
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(_lastKnownPosition?.latitude, _lastKnownPosition?.longitude),
          zoom: 14.0,
        ),
      ),
    );
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

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        setState(() {
        });
        // widget?.placeBloc?.getCurrentLocation(Place(
        //     formattedAddress: '',
        //     lat: currentLocation?.latitude,
        //     lng: currentLocation?.longitude
        // ));
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
        // widget?.placeBloc?.getCurrentLocation(Place(
        //   formattedAddress: '',
        //   lat: lat,
        //   lng: lng
        // ));
      }
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
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    changeMapType(3, 'assets/style/dark_mode.json');
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position;
    if(currentLocation == null){
      Position lastKnowPosition = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
      position = LatLng(lastKnowPosition.latitude, lastKnowPosition.longitude);
    }else{
      position = LatLng(currentLocation != null ? currentLocation?.latitude : 0.0, currentLocation != null ? currentLocation?.longitude : 0.0);
    }
    
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_marker_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_96.png'),
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
  
  @override
  Widget build(BuildContext context) {

    final responsive = Responsive(context);
    final pedidoProvider = Provider.of<PedidoProvider>(context);
    
    return Scaffold(
        key: _scaffoldKey,
        drawer: MenuScreens(activeScreenName: screenName),
        body: Stack(
          children: <Widget>[
            SizedBox(
              //height: MediaQuery.of(context).size.height - 180,
              child: GoogleMap(
                markers: Set<Marker>.of(_markers.values),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                polylines: Set<Polyline>.of(polyLines.values),
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation != null ? currentLocation?.latitude : _lastKnownPosition?.latitude ?? 0.0,
                      currentLocation != null ? currentLocation?.longitude : _lastKnownPosition?.longitude ?? 0.0),
                  zoom: 12.0,
                ),
                onCameraMove: (CameraPosition position) {
                  // if(_markers.length > 0) {
                  //   MarkerId markerId = MarkerId(_markerIdVal());
                  //   Marker marker = _markers[markerId];
                  //   Marker updatedMarker = marker?.copyWith(
                  //     positionParam: position?.target,
                  //   );
                  //   setState(() {
                  //     _markers[markerId] = updatedMarker;
                  //     _position = position;
                  //   });
                  // }
                },
                onCameraIdle: () => getLocationName(
                    // ignore: prefer_if_null_operators
                    _position?.target?.latitude != null ? _position?.target?.latitude : currentLocation?.latitude,
                    // ignore: prefer_if_null_operators
                    _position?.target?.longitude != null ? _position?.target?.longitude : currentLocation?.longitude
                ),
              ),
            ),
            !travelInits ? Container(
              width: responsive.wp(100),
              height: responsive.hp(30),
              color: Colors.grey.withOpacity(0.3),
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
              child: Column(
                children: <Widget>[
                  SizedBox(height: responsive.hp(15),),
                  Text('${pedidoProvider.requestDriver.vchNombres.split(' ')[0]} aceptó su pedido de S/${double.parse(pedidoProvider.requestDriver.mPrecio).toStringAsFixed(1)}', style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.w600, color: Colors.white),textAlign: TextAlign.center),
                  aproxElement != null ? Text('Está a ${aproxElement.duration.text}', style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.w600, color: Colors.white),textAlign: TextAlign.center) : Container()
                ],
              ),
            ) : Container(),
            Positioned(
              bottom: 0,
              child: Container(
                width: responsive.wp(94),
                margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                padding: EdgeInsets.all(responsive.wp(3)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Column(
                  children: <Widget>[
                    Text('Modelo: ${pedidoProvider.requestDriver.vchModelo}',style: TextStyle(fontSize: responsive.ip(2.2)),),
                    SizedBox(height: responsive.hp(2),),
                    Text('Placa: ${pedidoProvider.requestDriver.vchPlaca}',style: TextStyle(fontSize: responsive.ip(2.2))),
                    Divider(color: Colors.grey,),
                    ListTile(
                      leading: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CachedNetworkImage(
                            imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                            fit: BoxFit.cover,
                            width: responsive.wp(14),
                            height: responsive.wp(14)
                          ),
                        ),
                      ),
                      title: Text('${pedidoProvider.requestDriver.vchNombres}',style: TextStyle(fontSize: responsive.ip(2))),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.star, color: primaryColor,),
                          Text('4.8 (5)',style: TextStyle(fontSize: responsive.ip(1.8)))
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(FontAwesomeIcons.phoneAlt, color: Colors.green,),
                        onPressed: ()async{
                          final url = 'tel:${pedidoProvider.requestDriver.vchCelular}';
                          try{
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }catch(e){
                            Dialogs.alert(e);
                          }
                        },
                      )
                    )
                  ],
                )
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Container(
                  width: responsive.wp(100),
                  height: responsive.hp(7),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      FlatButton(onPressed: () async {
                        try{
                          Dialogs.openLoadingDialog(context);
                          bool respuesta = await pickupApi.cancelTravel(pedidoProvider.request.id);
                          if(respuesta){
                            PushMessage pushMessage = getIt<PushMessage>();
                            Map<String, String> data = {
                              'newCancel' : '1',
                              'idSolicitud': pedidoProvider.request.id
                            };
                            _prefs.isClientInTaxi = false;
                            pushMessage.sendPushMessage(token: pedidoProvider.requestDriver.token, title: 'Cancelación', description: 'El usuario ha cancelado el viaje', data: data);
                            timer?.cancel();
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
                          }else{
                            Navigator.pop(context);
                            Dialogs.alert(context,title: 'Error', message: 'No se pudo cancelar su viaje, vuelva intentarlo');
                          }
                         
                        }on ServerException catch(e){
                          Navigator.pop(context);
                          Dialogs.confirm(context,title: 'Error', message: e.message);
                        }
                      }, child: Text('Cancelar',style: TextStyle(fontSize: responsive.ip(2.2),color: redColor),))
                    ],
                  ),
                ),
              )
            )
          ],
        ),
    );
  }

}
import 'dart:async';
import 'dart:io' show Platform;

import 'package:HTRuta/app/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/coordenada_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/map_type_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app_router.dart';

class TravelScreen extends StatefulWidget {
  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  List<MapTypeModel> sampleData = new List<MapTypeModel>();
  PersistentBottomSheetController _controller;

  Position currentLocation;
  Position _lastKnownPosition;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  bool isEnabledLocation = false;

  final pickupApi = PickupApi();
  final referenceDatabase = FirebaseDatabase.instance.reference();
  Channel _channel;

  dynamic posicionChofer;

  @override
  void initState() {
    super.initState();
//    _initLastKnownLocation();
//    _initCurrentLocation();
    fetchLocation();
    fechDriverLocation();
    initPusher();
    // showPersBottomSheetCallBack = _showBottomSheet;
    sampleData.add(MapTypeModel(1,true, 'assets/style/maptype_nomal.png', 'Nomal', 'assets/style/nomal_mode.json'));
    sampleData.add(MapTypeModel(2,false, 'assets/style/maptype_silver.png', 'Silver', 'assets/style/sliver_mode.json'));
    sampleData.add(MapTypeModel(3,false, 'assets/style/maptype_dark.png', 'Dark', 'assets/style/dark_mode.json'));
    sampleData.add(MapTypeModel(4,false, 'assets/style/maptype_night.png', 'Night', 'assets/style/night_mode.json'));
    sampleData.add(MapTypeModel(5,false, 'assets/style/maptype_netro.png', 'Netro', 'assets/style/netro_mode.json'));
    sampleData.add(MapTypeModel(6,false, 'assets/style/maptype_aubergine.png', 'Aubergine', 'assets/style/aubergine_mode.json'));
  }

   Future<void> initPusher()async{ 
    try{
      await Pusher.init('4b1d6dd1d636f15f0e59', PusherOptions(cluster: 'us2'));
    }catch(e){
      print(e);
    }

    Pusher.connect(
      onConnectionStateChange: (val) {
          print(val.currentState);
      },
      onError: (error){
        
      }
    );

    _channel = await Pusher.subscribe('solicitud');

    _channel.bind('SendSolicitud', (onEvent) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeScreen, (route) => false);
    });

  }

  Future<void> fechDriverLocation() {
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
            icon: checkPlatform ? BitmapDescriptor.fromAsset("assets/image/marker/car_top_48.png") : BitmapDescriptor.fromAsset("assets/image/marker/car_top_96.png"),
          );
          setState(() {
            _markers[markerId] = marker;
          });
        }
      });
    });
  }

  ///Get last known location
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator?.getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {return;}
    _lastKnownPosition = position;
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
    currentLocation = await _locationService.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          _placemark = pos.name + ', ' + pos.thoroughfare;
        });
        // widget?.placeBloc?.getCurrentLocation(Place(
        //     name: _placemark,
        //     formattedAddress: "",
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
      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
          _placemark = pos.name + ', ' + pos.thoroughfare;
          print(_placemark);
        // widget?.placeBloc?.getCurrentLocation(Place(
        //   name: _placemark,
        //   formattedAddress: "",
        //   lat: lat,
        //   lng: lng
        // ));
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(currentLocation != null ? currentLocation?.latitude : 0.0, currentLocation != null ? currentLocation?.longitude : 0.0);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
      icon: checkPlatform ? BitmapDescriptor.fromAsset("assets/image/marker/ic_marker_48.png") : BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_96.png"),
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
                    _position?.target?.latitude != null ? _position?.target?.latitude : currentLocation?.latitude,
                    _position?.target?.longitude != null ? _position?.target?.longitude : currentLocation?.longitude
                ),
              ),
            ),

            Container(
              width: responsive.wp(100),
              height: responsive.hp(23),
              color: Colors.grey.withOpacity(0.3),
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
              child: Column(
                children: <Widget>[
                  SizedBox(height: responsive.hp(15),),
                  Text('${pedidoProvider.requestDriver.vchNombres.split(' ')[0]} aceptó su pedido de S/${double.parse(pedidoProvider.requestDriver.mPrecio).toStringAsFixed(1)}, llegará en 3 minutos', style: TextStyle(fontSize: responsive.ip(2.5), fontWeight: FontWeight.w600),textAlign: TextAlign.center,)
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                  height: responsive.hp(23),
                  width: responsive.wp(94),
                  margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  padding: EdgeInsets.all(responsive.wp(3)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  child: Column(
                    children: <Widget>[
                      Text('${pedidoProvider.requestDriver.vchMarca} ${pedidoProvider.requestDriver.vchModelo}',style: TextStyle(fontSize: responsive.ip(2.2)),),
                      SizedBox(height: responsive.hp(2),),
                      Text('${pedidoProvider.requestDriver.vchPlaca}',style: TextStyle(fontSize: responsive.ip(2.2))),
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
                      FlatButton(onPressed: (){
                        try{
                          Dialogs.openLoadingDialog(context);
                          pickupApi.cancelTravel(pedidoProvider.idSolicitud);
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeScreen, (route) => false);
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
            // Positioned(
            //     top: 0,
            //     left: 0,
            //     child: GestureDetector(
            //       onTap: (){
            //         _scaffoldKey.currentState.openDrawer();
            //       },
            //       child: Container(
            //         height: 40.0,
            //         width: 40.0,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.all(Radius.circular(100.0),),
            //         ),
            //         child: Icon(Icons.menu, color: blackColor,),
            //       ),
            //     )
            // ),
          ],
        ),
    );
  }

}
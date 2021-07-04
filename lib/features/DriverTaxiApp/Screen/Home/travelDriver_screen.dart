import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/map_network/map_network.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/core/push_message/push_notification.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/widgets/select_service_widget.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/loading.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:HTRuta/models/direction_model.dart';
// import 'package:HTRuta/features/DriverTaxiApp/Model/requestDriver_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/autoRotationMarker.dart' as rm;
import 'package:HTRuta/app_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';

import 'package:HTRuta/app/navigation/routes.dart' as enrutador;
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/entities/location_entity.dart';

class TravelDriverScreen extends StatefulWidget {

  @override
  _TravelDriverScreenState createState() => _TravelDriverScreenState();
}

class _TravelDriverScreenState extends State<TravelDriverScreen> with WidgetsBindingObserver {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> points = <LatLng>[];
  GoogleMapController _mapController;
  DriverFirestoreService driverFirestoreService = DriverFirestoreService();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  BitmapDescriptor markerIcon;

  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  bool checkPlatform = Platform.isIOS;
  String distance, duration;
  bool isLoading = false;
  bool isResult = false;
  LatLng positionDriver;
  bool isComplete = false;
  bool travelInit = false;
  bool travelFinish = false;
  var apis = MapNetwork();
  final pickupApi = PickupApi();
  final _prefs = UserPreferences();
  LatLng currentLocation;
  List<RoutesDirectionModel> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  PanelController panelController =PanelController();
  String selectedService;
  PushNotificationProvider pushProvider;
  bool nightMode = false;
  final pickUpApi = PickupApi();

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    changeMapType(3, 'assets/style/dark_mode.json');
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _mapController.setMapStyle('[]');
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    addMakers();
    getRouter();
    _initCurrentLocation();
    pushProvider = PushNotificationProvider();
    pushProvider.mensajes.listen((argumento) async{
      Map data = argumento['data'];
      if(data == null) return;
      String newCancel = data['newCancel'] ?? '0';
      String idSolicitud = data['idSolicitud'] ?? '0';
      if (!mounted) return;
      if(newCancel == '1'){
        final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
        if(idSolicitud == pedidoProvider.request.idSolicitud){
          final _prefs = UserPreferences();
          _prefs.setNotificacionConductor = 'Viajes,El usuario canceló el viaje';
          Fluttertoast.showToast(
            msg: 'Se canceló el viaje',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
        _prefs.isDriverInService = false;
        Navigator.pushAndRemoveUntil(context, enrutador.Routes.toHomeDriverPage(), (_) => false);
        // Navigator.of(context).pushReplacementNamed(AppRoute.requestDriverScreen);
      }
    });
    Geolocator.getPositionStream().listen((event) async{
      if(currentLocation  == null) return;
      double diferencia = await Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, event.latitude, event.longitude);
      if(diferencia > 10 && mounted){
        final _prefs = UserPreferences();
        final MarkerId _markerMy = MarkerId('from_address');
        if(currentLocation != null){
          markers[_markerMy] = GMapViewHelper.createMaker(
            markerIdVal: 'fromLocation',
            icon: 'assets/image/marker/taxi_marker.png',
            lat: event.latitude,
            lng: event.longitude,
          );
          driverFirestoreService.updateDriverPosition(event.latitude, event.longitude, _prefs.idChofer);
        }
      }
      currentLocation = LatLng(event.latitude, event.longitude);
    });
    // initPusher();
    super.initState();
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
    if(!mounted) return;
    setState(() {
      markers[markerIdFrom] = marker;
      markers[markerIdTo] = markerTo;
    });
  }
  Future<void> _initCurrentLocation() async {
    LocationEntity locationEntity = await LocationUtil.currentLocation();
    currentLocation = locationEntity.latLang;
  }

  ///Calculate and return the best router
  void getRouter() async {
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
    }).catchError((error) {
    });
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
    if(!mounted) return;
    setState(() {});
    _gMapViewHelper.cameraMove(fromLocation: _fromLocation,toLocation: _toLocation,mapController: _mapController);
  }

  ///Real-time test of driver's location
  ///My data is demo.
  ///This function works by: every 5 or 2 seconds will request for api and after the data returns,
  ///the function will update the driver's position on the map.

  double valueRotation;
  void runTrackingDriver(var _listPosition){
    int count = 1;
    int two = count;
    const timeRequest = Duration(seconds: 2);
    Timer.periodic(timeRequest, (Timer t) {
      LatLng positionDriverBefore = _listPosition[two-1];
      positionDriver = _listPosition[count++];

      valueRotation = rm.calculateangle(positionDriverBefore.latitude, positionDriverBefore.longitude,positionDriver.latitude, positionDriver.longitude);
      addMakersDriver(positionDriver);
      _mapController?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: positionDriver,
            zoom: 15.0,
          ),
        ),
      );
      if(count == _listPosition.length){
        if(!mounted) return;
        setState(() {
          t.cancel();
          isComplete = true;
          showDialog(context: context, child: dialogInfo());
        });

      }
    });
  }

  void addMakersDriver(LatLng _position){
    final MarkerId markerDriver = MarkerId('driver');
    final Marker marker = Marker(
      markerId: markerDriver,
      position: _position,
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/icon_car_32.png') : BitmapDescriptor.fromAsset('assets/image/icon_car_120.png'),
      draggable: false,
      rotation: 0.0,
      consumeTapEvents: true,
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    if(!mounted) return;
    setState(() {
      markers[markerDriver] = marker;
    });
  }

  AlertDialog dialogOption(){

    return AlertDialog(
      title: Text('Opcion'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      content: Container(
        child: TextFormField(
          style: textStyle,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //border: InputBorder.none,
            hintText: 'Ejemplo: Estoy parado frente a la parada del bus...',
            // hideDivider: true
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Ok'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),

      ],
    );
  }

  // dialogPromoCode(){
  //   return AlertDialog(
  //     title: Text('Codigo Promoción'),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0)
  //     ),
  //     content: Container(
  //       child: TextFormField(
  //         style: textStyle,
  //         keyboardType: TextInputType.text,
  //         decoration: InputDecoration(
  //           //border: InputBorder.none,
  //           hintText: 'Ingresa código de promoción',
  //           // hideDivider: true
  //         ),
  //       ),
  //     ),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: Text('Confirmar'),
  //         onPressed: (){
  //           Navigator.of(context).pop();
  //         },
  //       )
  //     ],
  //   );
  // }

  // handSubmit(){
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Timer(Duration(seconds: 5), () {
  //     setState(() {
  //       isLoading = false;
  //       isResult = true;
  //     });
  //   });
  // }

  // ignore: always_declare_return_types
  dialogInfo(){
    AlertDialog(
      title: Text('Información'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      content: Text('Viaje completado. Revisa tu viaje ahora!.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoute.reviewTripScreen);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context);
    final responsive = Responsive(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildContent(context),
          Positioned(
            bottom: 0,
            child: Container(
              // height: responsive.hp(26),
              width: responsive.wp(94),
              margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
              padding: EdgeInsets.all(responsive.wp(4)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Recoger al cliente en'.toUpperCase(),style: textGreyBold,),
                  Text('${pedidoProvider.request.vchNombreInicial}',style: TextStyle(fontSize: responsive.ip(1.8)), textAlign: TextAlign.center,),
                  SizedBox(height: responsive.hp(2),),
                  Text('Destino'.toUpperCase(),style: textGreyBold,),
                  Text('${pedidoProvider.request.vchNombreFinal}',style: TextStyle(fontSize: responsive.ip(1.8)),textAlign: TextAlign.center,),
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
                    title: Text('${pedidoProvider.request.vchNombres}',style: TextStyle(fontSize: responsive.ip(2))),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.star, color: primaryColor,),
                        Text('4.8 (5)',style: TextStyle(fontSize: responsive.ip(1.8)))
                      ],
                    ),
                    trailing: !travelInit ? IconButton(
                      icon: Icon(FontAwesomeIcons.phoneAlt, color: Colors.green,),
                      onPressed: ()async{
                        final url = 'tel:${pedidoProvider.request.vchCelular}';
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
                    ): Container()
                  ),
                  !travelInit ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: primaryColor,
                        child: Text('Empezar viaje', style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        onPressed: (){
                          Dialogs.confirm(
                            context,
                            title: 'Atención', 
                            message: '¿Desea comenzar el viaje?',
                            onConfirm: () async{
                              PushMessage pushMessage = getIt<PushMessage>();
                              Map<String, String> data = {
                                'travelInit' : '1'
                              };
                              pushMessage.sendPushMessage(token: pedidoProvider.request.token, title: 'Inicio de viaje', description: 'El chofer lo llevará a su destino', data: data);
                              travelInit = true;
                              setState(() {});
                            },
                            onCancel: (){
                              Navigator.pop(context);
                            },
                            textoConfirmar: 'Si',
                            textoCancelar: 'No'
                          );
                        },
                      ),
                    ],
                  ) : Container(),
                  travelInit ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Colors.blue.withOpacity(0.8),
                        child: Text('Finalizar viaje', style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        onPressed: (){
                          Dialogs.confirm(
                            context,
                            title: 'Atención', 
                            message: '¿Desea finalizar el viaje?',
                            onConfirm: () async{
                              final _prefs = UserPreferences();
                              _prefs.setNotificacionConductor = 'Viajes,El viaje ha concluido';
                              PushMessage pushMessage = getIt<PushMessage>();
                              Map<String, String> data = {
                                'travelFinish' : '1',
                                'idSolicitud': pedidoProvider.request.idSolicitud
                              };
                              _prefs.isDriverInService = false;
                              pushMessage.sendPushMessage(token: pedidoProvider.request.token, title: 'Su viaje ha terminado', description: 'Si desea puede completar la siguiente encuesta', data: data);
                              Navigator.pushAndRemoveUntil(context, enrutador.Routes.toHomeDriverPage(), (_) => false);
                            },
                            onCancel: (){
                              Navigator.pop(context);
                            },
                            textoConfirmar: 'Si',
                            textoCancelar: 'No'
                          );
                          
                        },
                      ),
                    ],
                  ) : Container()
                ],
              )
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : Container(),
          Positioned(
            left: 18,
            top: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  centerTitle: true,
                  leading: GestureDetector(
                      onTap: () {
                        Dialogs.confirm(context,title: 'Advertencia', message: '¿Desea cancelar la solicitud de viaje?',
                          onConfirm: () async{
                            final respuesta = await pickUpApi.cancelTravel(pedidoProvider.request.idSolicitud);
                            if(respuesta){
                              PushMessage pushMessage = getIt<PushMessage>();
                              Map<String, String> data = {
                                'newCancel' : '1',
                                'idSolicitud': pedidoProvider.request.idSolicitud
                              };
                              _prefs.isDriverInService = false;
                              pushMessage.sendPushMessage(token: pedidoProvider.request.token, title: 'Cancelación', description: 'El chofer ha cancelado el viaje', data: data);
                              Navigator.pushAndRemoveUntil(context, enrutador.Routes.toHomeDriverPage(), (_) => false);
                              // Navigator.of(context).pushReplacementNamed(AppRoute.requestDriverScreen);
                            }else{
                              Navigator.pop(context);
                              Dialogs.alert(context,title: 'Error', message: 'No se pudo cancelar su viaje, vuelva intentarlo');
                            }
                          },
                          onCancel: (){
                            Navigator.pop(context);
                          },
                          textoConfirmar: 'Si',
                          textoCancelar: 'No'
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white
                        ),
                        child: Icon(Icons.arrow_back_ios,color: blackColor,)
                      )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context){
    final screenSize = MediaQuery.of(context).size;
    final pedidoProvider = Provider.of<PedidoProvider>(context);

    return SlidingUpPanel(
      controller: panelController,
      maxHeight: screenSize.height*0.8,
      minHeight: 0.0,
      parallaxEnabled: false,
      parallaxOffset: 0.8,
      backdropEnabled: false,
      renderPanelSheet: false,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      body: Stack(
        children: <Widget>[
          SizedBox(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(pedidoProvider.request.vchLatInicial), double.parse(pedidoProvider.request.vchLongInicial)),
                zoom: 13,
              ),
              markers: Set<Marker>.of( markers.values),
              polylines: Set<Polyline>.of(polyLines.values),
            )
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Material(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
              ),
              child: Container(),
            ),
          ),
        ],
      ),
      panel: SelectServiceWidget(
        serviceSelected: selectedService,
        panelController: panelController,
      ),
    );
  }

  Widget searchDriver(BuildContext context){
    return Container(
        height: 270.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: LoadingBuilder(),
            ),
            SizedBox(height: 20),
            Text('Buscando un conductor',
              style: TextStyle(
                fontSize: 18,
                color: greyColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        )
    );
  }
}
import 'dart:async';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/map_network/map_network.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/core/push_message/push_notification.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/pickupdriver_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:HTRuta/models/direction_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/loading.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/widgets/booking_detail_widget.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/app_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'widgets/select_service_widget.dart';
import 'package:HTRuta/app/navigation/routes.dart';

class DirectionsView extends StatefulWidget {
  final ClientTaxiPlaceBloc placeBloc;
  DirectionsView({this.placeBloc});

  @override
  _DirectionsViewState createState() => _DirectionsViewState();
}

class _DirectionsViewState extends State<DirectionsView> with WidgetsBindingObserver {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> points = <LatLng>[];
  GoogleMapController _mapController;

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
  var apis = MapNetwork();
  List<RoutesDirectionModel> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  PanelController panelController =PanelController();
  String selectedService;
  final _prefs = UserPreferences();
  final pickUpApi = PickupApi();
  List<DriverRequest> requestTaxi = [];
  List<Map> driversData = [];
  PushNotificationProvider pushProvider;
  PedidoProvider pedidoProvider;
  bool nightMode = false;
  Position currentLocation;
  

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
    pushProvider = PushNotificationProvider();
    pushProvider.mensajes.listen((argumento) async{
      Map data = argumento['data'];
      if(data == null) return;
      String newOffer = data['newOffer'] ?? '0';
      String newReffuse = data['newReffuse'] ?? '0';
      String idChofer = data['idChofer'] ?? '0';
      if (!mounted) return;
      if(newOffer == '1'){
        _prefs.setNotificacionUsuario = 'Solicitudes,Tiene una nueva oferta de conductor';
        await loadOffers();
      }
      if(newReffuse == '1'){
        _prefs.setNotificacionUsuario = 'Solicitudes,El conductor canceló su solicitud';
        await pickUpApi.cancelTravelUser(pedidoProvider.idSolicitud, idChofer);
        await loadOffers();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    addMakers();
    getRouter();
    Geolocator.getCurrentPosition().then((position) =>{
      currentLocation = position
    });
    locationlistener();
    super.initState();
  }
  void locationlistener(){
    Geolocator.getPositionStream(distanceFilter: 15).listen((event) async{
      currentLocation = Position(latitude: event.latitude, longitude: event.longitude);
    });
  }
  Future<void> loadOffers() async {
    final data = await pickUpApi.getRequestDriver(pedidoProvider.idSolicitud);
    if(data == null){
      requestTaxi.clear();
      setState(() {});
    }else{
      List<String> ids = data.map((e) => e.iIdUsuario).toList();
      Query reference = FirebaseFirestore.instance.collection('taxis_in_service').where('id', whereIn: ids);
      QuerySnapshot snapshot = await reference.get();
      final driverDocs = snapshot.docs;
      driversData.clear();
      driverDocs.forEach((element) {
        final data = element.data();
        driversData.add(data);
      });
      requestTaxi.clear();
      requestTaxi.addAll(data);
      setState(() {});
    }
  }

  void addMakers(){
    final MarkerId markerIdFrom = MarkerId('from_address');
    final MarkerId markerIdTo = MarkerId('to_address');

    final Marker marker = Marker(
      markerId: markerIdFrom,
      position: LatLng(widget?.placeBloc?.formLocation?.lat, widget?.placeBloc?.formLocation?.lng),
      infoWindow: InfoWindow(title: widget?.placeBloc?.formLocation?.name, snippet: widget?.placeBloc?.formLocation?.formattedAddress),
      // ignore: deprecated_member_use
      icon:  checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_96.png'),
      onTap: () {
      },
    );

    final Marker markerTo = Marker(
      markerId: markerIdTo,
      position: LatLng(widget?.placeBloc?.locationSelect?.lat, widget?.placeBloc?.locationSelect?.lng),
      infoWindow: InfoWindow(title: widget?.placeBloc?.locationSelect?.name, snippet: widget?.placeBloc?.locationSelect?.formattedAddress),
      // ignore: deprecated_member_use
      // ignore: deprecated_member_use
      icon: checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_pick_48.png'),
      onTap: () {
      },
    );

    setState(() {
      markers[markerIdFrom] = marker;
      markers[markerIdTo] = markerTo;
    });
  }

  ///Calculate and return the best router
  void getRouter() async {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    polyLines.clear();
    var router;
    LatLng _fromLocation = LatLng(widget?.placeBloc?.formLocation?.lat, widget?.placeBloc?.formLocation?.lng);
    LatLng _toLocation = LatLng(widget?.placeBloc?.locationSelect?.lat, widget?.placeBloc?.locationSelect?.lng);

    await apis.getRoutes(
      getRoutesRequest: GetRoutesRequestModel(
        fromLocation: _fromLocation,
        toLocation: _toLocation,
        mode: 'driving'
      ),
    ).then((data) {
      if (data != null) {
        router = data?.result?.routes[0]?.overviewPolyline?.points;
        routesData = data?.result?.routes;
      }
    }).catchError((_) {});

    distance = routesData[0]?.legs[0]?.distance?.text;
    duration = routesData[0]?.legs[0]?.duration?.text;

    polyLines[polylineId] = GMapViewHelper.createPolyline(
      polylineIdVal: polylineIdVal,
      router: router,
    );
    setState(() {});
    _gMapViewHelper.cameraMove(fromLocation: _fromLocation,toLocation: _toLocation,mapController: _mapController);
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
    setState(() {
      markers[markerDriver] = marker;
    });
  }

  void handSubmit(){
    setState(() {
      isLoading = true;
    });
    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
        isResult = true;
      });
    });
  }
  List<AproximationGroup> aproximationsLoaded = [];

  @override
  Widget build(BuildContext context) {
    pedidoProvider = Provider.of<PedidoProvider>(context);
    final responsive = Responsive(context);
    return Stack(
      children: <Widget>[
        buildContent(context),
        Positioned(
          top: responsive.hp(15),
          left: responsive.wp(17),
          child: Container(
            color: Colors.grey.withOpacity(0.05),
            child: Text('Ofreciendo su tarifa, espere', style: TextStyle(fontSize: responsive.ip(2.2),fontWeight: FontWeight.w600, color: Colors.white))
            )
        ),
        Positioned(
          top: responsive.hp(25),
          left: responsive.wp(20),
          child: LoadingBuilder(),
        ),
        requestTaxi.isEmpty ? Container() : Positioned(
          top: responsive.hp(12),
          child: Container(
            width: responsive.wp(100),
            height: responsive.hp(88),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2),vertical: responsive.hp(2)),
            color: Colors.grey.withOpacity(0.7),
            child: Column(
              children: <Widget>[
                Text('Puede aceptar o rechazar ofertas', style: TextStyle(fontSize: responsive.ip(2.6),color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: responsive.hp(1),),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestTaxi.length,
                  itemBuilder: (context, index) {
                    final actualRequest = requestTaxi[index];
                    bool included = false;
                    AproximationGroup data;
                    aproximationsLoaded.forEach((element) {
                      if(element.id == actualRequest.idChofer){
                        included = true;
                        data = element;
                      }
                    });
                    // final GeoPoint driverLocation = driversData[index]['posicion'];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(top: responsive.hp(1),left: responsive.wp(2),right: responsive.wp(2), bottom: responsive.hp(1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: actualRequest.urlDriver != null && actualRequest.urlDriver.isNotEmpty ? CachedNetworkImage(
                                      imageUrl: actualRequest.urlDriver,
                                      fit: BoxFit.cover,
                                      width: responsive.wp(14),
                                      height: responsive.wp(14)
                                    ) : Image.asset(
                                      'assets/image/empty_user_photo.png',
                                      width: responsive.wp(14),
                                      height: responsive.wp(14)
                                    ),
                                  ),
                                ),
                                SizedBox(width: responsive.wp(2),),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${actualRequest.vchNombres}',style: TextStyle(fontSize: responsive.ip(2))),
                                    Text('${actualRequest.vchMarca} ${actualRequest.vchModelo}',style: TextStyle(fontSize: responsive.ip(2)),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.star,color: primaryColor,),
                                        SizedBox(width: responsive.wp(1),),
                                        Text('4,9 (5)', style: TextStyle(fontSize: responsive.ip(2))),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                /* Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text('S/${double.parse(actualRequest.mPrecio)}',style: TextStyle(fontSize: responsive.ip(3))),
                                    !included ? FutureBuilder(
                                      future: pickUpApi.calculateMinutes(currentLocation.latitude, currentLocation.longitude, driverLocation.latitude, driverLocation.longitude),
                                      builder: (BuildContext context, AsyncSnapshot snapshot){
                                        if(snapshot.hasError) return Container();
                                        switch(snapshot.connectionState){
                                          case ConnectionState.waiting: return Container();
                                          case ConnectionState.none: return Container();
                                          case ConnectionState.active: {
                                            final AproxElement element = snapshot.data;
                                            aproximationsLoaded.add(AproximationGroup(actualRequest.idChofer, element.duration.text, element.distance.text));
                                            return Column(
                                              children: [
                                                Text(element.distance.text, style: TextStyle(fontSize: responsive.ip(2))),
                                                Text(element.duration.text, style: TextStyle(fontSize: responsive.ip(2), color: greyColor2)),
                                              ]
                                            );
                                          }
                                          case ConnectionState.done: {
                                            final AproxElement element = snapshot.data;
                                            aproximationsLoaded.add(AproximationGroup(actualRequest.idChofer, element.duration.text, element.distance.text));
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(element.distance.text, style: TextStyle(fontSize: responsive.ip(2))),
                                                Text(element.duration.text, style: TextStyle(fontSize: responsive.ip(2))),
                                              ]
                                            );
                                          }
                                        }
                                        return Container();
                                      }
                                    ) : Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(data.kilometers, style: TextStyle(fontSize: responsive.ip(2))),
                                        Text(data.minutes, style: TextStyle(fontSize: responsive.ip(2))),
                                      ]
                                    ),
                                    // Text('3 min.',style: TextStyle(fontSize: responsive.ip(2))),
                                  ],
                                ) */
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: ButtonTheme(
                                      height: 45.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
                                        elevation: 0.0,
                                        color: Colors.redAccent,
                                        child: Text('Rechazar',style: headingWhite,
                                        ),
                                        onPressed: ()async{
                                          try{
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await pickUpApi.cancelTravelUser(pedidoProvider.idSolicitud, actualRequest.idChofer);
                                            PushMessage pushMessage = getIt<PushMessage>();
                                            Map<String, String> data = {
                                              'newCancelSol' : '1',
                                            };
                                            pushMessage.sendPushMessage(token: actualRequest.token, title: 'Negación', description: 'El usuario rechazó su oferta', data: data);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            loadOffers();
                                          } on ServerException catch(error){
                                            Navigator.pop(context);
                                            Dialogs.alert(context, title: 'Error', message: '${error.message}');
                                          }
                                          //navigateToDetail(requestActual);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: ButtonTheme(
                                      height: 45.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
                                        elevation: 0.0,
                                        color: primaryColor,
                                        child: Text('Aceptar',style: headingWhite,
                                        ),
                                        onPressed: ()async{
                                          try{
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await pickUpApi.prepareTravel(pedidoProvider.idSolicitud);
                                            String idViaje = await pickUpApi.acceptDriverRequest(pedidoProvider.idSolicitud, actualRequest.idChofer);
                                            if(idViaje == null){
                                              Dialogs.alert(context, title: 'Error', message: 'No se pudo aceptar la solicitud');
                                              return;
                                            }
                                            _prefs.setNotificacionUsuario = 'Solicitudes, Ha aceptado la oferta de un conductor';
                                            PushMessage pushMessage = getIt<PushMessage>();
                                            Map<String, String> data = {
                                              'newConfirm' : '1',
                                              'idSolicitud': pedidoProvider.idSolicitud,
                                            };
                                            pushMessage.sendPushMessage(token: actualRequest.token, title: 'Confirmación', description: 'El usuario aceptó su oferta', data: data);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            pedidoProvider.requestDriver = actualRequest;
                                            _prefs.clientTaxiRequest = requestItemToJson(pedidoProvider.request);
                                            _prefs.clientTaxiDriverRequest = requestDriverItemToJson(pedidoProvider.requestDriver);
                                            _prefs.isClientInTaxi = true;
                                            pedidoProvider.idViaje = idViaje;
                                            Navigator.pushNamedAndRemoveUntil(context, AppRoute.travelScreen, (route) => true);
                                          } on ServerException catch(error){
                                            Navigator.pop(context);
                                            Dialogs.alert(context, title: 'Error', message: '${error.message}');
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
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
                        final respuesta = await pickUpApi.cancelTravel(pedidoProvider.idSolicitud);
                        if(respuesta){
                          PushMessage pushMessage = getIt<PushMessage>();
                          Map<String, String> data = {
                            'newCancelSol' : '1',
                          };
                          DriverFirestoreService driverFirestoreService = DriverFirestoreService();
                          List<String> tokens = await driverFirestoreService.getDrivers();
                          pushMessage.sendPushMessageBroad(tokens: tokens, title: 'Cancelación', description: 'El usuario ha cancelado el viaje', data: data);
                          Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
                          // BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: serviceInCourse.serviceType));
                          // Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(serviceInCourse: serviceInCourse), (_) => false);
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
    );
  }

  Widget buildContent(BuildContext context){
    final screenSize = MediaQuery.of(context).size;

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
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget?.placeBloc?.locationSelect?.lat, widget?.placeBloc?.locationSelect?.lng),
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
              child: BookingDetailWidget(
                bookingSubmit: handSubmit,
                panelController: panelController,
                distance: distance,
                duration: duration,
                // onTapOptionMenu: () => showDialog(context: context, child: dialogOption()),
                // onTapPromoMenu: () => showDialog(context: context, child: dialogPromoCode()),
              ),
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
class AproximationGroup{
  String id;
  String minutes;
  String kilometers;
  AproximationGroup(this.id, this.minutes, this.kilometers);
}
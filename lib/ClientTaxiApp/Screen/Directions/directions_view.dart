import 'dart:async';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/ClientTaxiApp/Components/loading.dart';
import 'package:HTRuta/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/ClientTaxiApp/Screen/Directions/widgets/booking_detail_widget.dart';
import 'package:HTRuta/ClientTaxiApp/theme/style.dart';
import 'package:HTRuta/ClientTaxiApp/Components/autoRotationMarker.dart' as rm;
import 'package:HTRuta/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/ClientTaxiApp/utils/exceptions.dart';
import 'package:HTRuta/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/DriverTaxiApp/Model/requestDriver_model.dart';
import 'package:HTRuta/app_router.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../google_map_helper.dart';
import '../../Networking/Apis.dart';
import '../../data/Model/direction_model.dart';
import '../../data/Model/get_routes_request_model.dart';

import 'widgets/select_service_widget.dart';

class DirectionsView extends StatefulWidget {
  final PlaceBloc placeBloc;
  DirectionsView({this.placeBloc});

  @override
  _DirectionsViewState createState() => _DirectionsViewState();
}

class _DirectionsViewState extends State<DirectionsView> {
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
  var apis = Apis();
  List<Routes> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  PanelController panelController = new PanelController();
  String selectedService;

  Channel _channel;
  final pickUpApi = PickupApi();
  List<RequestDriverData> requestTaxi = List<RequestDriverData>();


  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      // final providerData = Provider.of<PedidoProvider>(context,listen: false);
      // final data = await pickUpApi.getRequestDriver(providerData.idSolicitud);
      // if(data != null){
      //   requestTaxi.addAll(data);
      //   setState(() {
      //     print(requestTaxi[0].toString());
      //   });
      // }
    });
    initPusher();
    print(widget?.placeBloc?.formLocation);
    print(widget?.placeBloc?.locationSelect);
    addMakers();
    getRouter();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  addMakers(){
    checkPlatform ? print('ios'): print("android");
    final MarkerId markerIdFrom = MarkerId("from_address");
    final MarkerId markerIdTo = MarkerId("to_address");

    final Marker marker = Marker(
      markerId: markerIdFrom,
      position: LatLng(widget?.placeBloc?.formLocation?.lat, widget?.placeBloc?.formLocation?.lng),
      infoWindow: InfoWindow(title: widget?.placeBloc?.formLocation?.name, snippet: widget?.placeBloc?.formLocation?.formattedAddress),
      icon:  checkPlatform ? BitmapDescriptor.fromAsset("assets/image/marker/ic_dropoff_48.png") : BitmapDescriptor.fromAsset("assets/image/marker/ic_dropoff_96.png"),
      onTap: () {
      },
    );

    final Marker markerTo = Marker(
      markerId: markerIdTo,
      position: LatLng(widget?.placeBloc?.locationSelect?.lat, widget?.placeBloc?.locationSelect?.lng),
      infoWindow: InfoWindow(title: widget?.placeBloc?.locationSelect?.name, snippet: widget?.placeBloc?.locationSelect?.formattedAddress),
      icon: checkPlatform ? BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_48.png") : BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_48.png"),
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
          mode: "driving"
      ),
    ).then((data) {
      if (data != null) {
        router = data?.result?.routes[0]?.overviewPolyline?.points;
        routesData = data?.result?.routes;
      }
    }).catchError((error) {
      print("GetRoutesRequest > $error");
    });

    distance = routesData[0]?.legs[0]?.distance?.text;
    duration = routesData[0]?.legs[0]?.duration?.text;

    polyLines[polylineId] = GMapViewHelper.createPolyline(
      polylineIdVal: polylineIdVal,
      router: router,
      formLocation: _fromLocation,
      toLocation: _toLocation,
    );
    setState(() {});
    _gMapViewHelper.cameraMove(fromLocation: _fromLocation,toLocation: _toLocation,mapController: _mapController);
  }

  ///Real-time test of driver's location
  ///My data is demo.
  ///This function works by: every 5 or 2 seconds will request for api and after the data returns,
  ///the function will update the driver's position on the map.

  double valueRotation;
  runTrackingDriver(var _listPosition){
    int count = 1;
    int two = count;
    const timeRequest = const Duration(seconds: 2);
    Timer.periodic(timeRequest, (Timer t) {
      LatLng positionDriverBefore = _listPosition[two-1];
      positionDriver = _listPosition[count++];
      print(count);

      valueRotation = rm.calculateangle(positionDriverBefore.latitude, positionDriverBefore.longitude,positionDriver.latitude, positionDriver.longitude);
      print(valueRotation);
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
        setState(() {
          t.cancel();
          isComplete = true;
          showDialog(context: context, child: dialogInfo());
        });

      }
    });
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
        print(error.message);
      }
    );

    _channel = await Pusher.subscribe('solicitud');
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);

    await _channel.bind('SendSolicitudChofer${pedidoProvider.idSolicitud}', (onEvent) {
      print(onEvent.data);
      requestTaxi.clear();
      requestTaxi.addAll(requestDriverFromJson(onEvent.data));
      setState(() {
        
      });
    });
  }

  addMakersDriver(LatLng _position){
    final MarkerId markerDriver = MarkerId("driver");
    final Marker marker = Marker(
      markerId: markerDriver,
      position: _position,
      icon: checkPlatform ? BitmapDescriptor.fromAsset("assets/image/icon_car_32.png") : BitmapDescriptor.fromAsset("assets/image/icon_car_120.png"),
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

  dialogOption(){

    return AlertDialog(
      title: Text("Opcion"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      content: Container(
        child: TextFormField(
          style: textStyle,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //border: InputBorder.none,
            hintText: "Ejemplo: Estoy parado frente a la parada del bus...",
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

  dialogPromoCode(){
    return AlertDialog(
      title: Text("Codigo Promoción"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      content: Container(
        child: TextFormField(
          style: textStyle,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //border: InputBorder.none,
            hintText: "Ingresa código de promoción",
            // hideDivider: true
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Confirmar'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  handSubmit(){
    print("Enviar");
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

  dialogInfo(){
    AlertDialog(
      title: Text("Información"),
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
    return Stack(
      children: <Widget>[
        buildContent(context),
        Positioned(
          top: responsive.hp(15),
          left: responsive.wp(17),
          child: Container(
            color: Colors.grey.withOpacity(0.05),
            child: Text('Ofreciendo su tarifa, espere', style: TextStyle(fontSize: responsive.ip(2.2),fontWeight: FontWeight.w600),)
            )
        ),
        Positioned(
          top: responsive.hp(25),
          left: responsive.wp(20),
          child: LoadingBuilder(),
        ),
        requestTaxi.length == 0 ? Container() : Positioned(
          top: responsive.hp(12),
          child: Container(
            width: responsive.wp(100),
            height: responsive.hp(88),
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2),vertical: responsive.hp(2)),
            color: Colors.grey.withOpacity(0.7),
            child: Column(
              children: <Widget>[
                Text('Puede aceptar o rechazar ofertas', style: TextStyle(fontSize: responsive.ip(2.6),color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(height: responsive.hp(1),),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestTaxi.length,
                  itemBuilder: (context, index) {
                    final actualRequest = requestTaxi[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(top: responsive.hp(1),left: responsive.wp(2),right: responsive.wp(2), bottom: responsive.hp(1)),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
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
                                SizedBox(width: responsive.wp(2),),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${actualRequest.vchNombres}',style: TextStyle(fontSize: responsive.ip(2))),
                                    Text('${actualRequest.vchMarca} ${actualRequest.vchModelo}',style: TextStyle(fontSize: responsive.ip(2)),),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text('S/${double.parse(actualRequest.mPrecio)}',style: TextStyle(fontSize: responsive.ip(3))),
                                    Text('3 min.',style: TextStyle(fontSize: responsive.ip(2))),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(width: responsive.wp(16),),
                                Icon(Icons.star,color: primaryColor,),
                                SizedBox(width: responsive.wp(1),),
                                Text('4,9 (5)', style: TextStyle(fontSize: responsive.ip(2))),
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
                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                        elevation: 0.0,
                                        color: Colors.redAccent,
                                        child: Text('Rechazar',style: headingWhite,
                                        ),
                                        onPressed: ()async{
                                          try{
                                            setState(() {
                                              isLoading = true;
                                            });
                                            pickUpApi.cancelTravelUser(pedidoProvider.idSolicitud, actualRequest.iIdUsuario);
                                            setState(() {
                                              isLoading = false;
                                            });
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
                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                        elevation: 0.0,
                                        color: primaryColor,
                                        child: Text('Aceptar',style: headingWhite,
                                        ),
                                        onPressed: ()async{
                                          try{
                                            setState(() {
                                              isLoading = true;
                                            });
                                            pickUpApi.acceptTravelFinish(pedidoProvider.idSolicitud, actualRequest.iIdUsuario);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            pedidoProvider.requestDriver = actualRequest;
                                            Navigator.pushNamedAndRemoveUntil(context, AppRoute.travelScreen, (route) => true);
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
                            Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
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
    print(selectedService);

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
                onTapOptionMenu: () => showDialog(context: context, child: dialogOption()),
                onTapPromoMenu: () => showDialog(context: context, child: dialogPromoCode()),
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

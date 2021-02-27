import 'dart:async';
import 'dart:io' show Platform;

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/widgets/select_service_widget.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/loading.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/requestDriver_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/autoRotationMarker.dart' as rm;
import 'package:HTRuta/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../google_map_helper.dart';
import '../../Networking/Apis.dart';
import '../../data/Model/direction_model.dart';
import '../../data/Model/get_routes_request_model.dart';

class TravelDriverScreen extends StatefulWidget {

  @override
  _TravelDriverScreenState createState() => _TravelDriverScreenState();
}

class _TravelDriverScreenState extends State<TravelDriverScreen> {
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
  PanelController panelController =PanelController();
  String selectedService;

  Channel _channel;
  final pickUpApi = PickupApi();
  List<RequestDriverData> requestTaxi = List<RequestDriverData>();


  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
  }

  @override
  void initState() {
    addMakers();
    getRouter();
    initPusher();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.requestDriverScreen, (route) => false);
    });

  }

  addMakers(){
    checkPlatform ? print('ios'): print('android');
    final MarkerId markerIdFrom = MarkerId('from_address');
    final MarkerId markerIdTo = MarkerId('to_address');
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);

    final Marker marker = Marker(
      markerId: markerIdFrom,
      position: LatLng(double.parse(pedidoProvider.request.vchLatInicial), double.parse(pedidoProvider.request.vchLongInicial)),
      infoWindow: InfoWindow(title: 'Recojo', snippet: pedidoProvider.request.vchNombreInicial),
      icon:  checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_96.png'),
      onTap: () {
      },
    );

    final Marker markerTo = Marker(
      markerId: markerIdTo,
      position: LatLng(double.parse(pedidoProvider.request.vchLatFinal), double.parse(pedidoProvider.request.vchLongFinal)),
      infoWindow: InfoWindow(title: 'Dejar', snippet: pedidoProvider.request.vchNombreFinal),
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
    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
    polyLines.clear();
    var router;
    LatLng _fromLocation = LatLng(double.parse(pedidoProvider.request.vchLatInicial), double.parse(pedidoProvider.request.vchLongInicial));
    LatLng _toLocation = LatLng(double.parse(pedidoProvider.request.vchLatFinal), double.parse(pedidoProvider.request.vchLongFinal));

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
    }).catchError((error) {
      print('GetRoutesRequest > $error');
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
  void runTrackingDriver(var _listPosition){
    int count = 1;
    int two = count;
    const timeRequest = Duration(seconds: 2);
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

  void addMakersDriver(LatLng _position){
    final MarkerId markerDriver = MarkerId('driver');
    final Marker marker = Marker(
      markerId: markerDriver,
      position: _position,
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
  //   print('Enviar');
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
                    height: responsive.hp(26),
                    width: responsive.wp(94),
                    margin: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    padding: EdgeInsets.all(responsive.wp(4)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                    child: Column(
                      children: <Widget>[
                        Text('${pedidoProvider.request.vchNombreInicial}',style: TextStyle(fontSize: responsive.ip(2.0)), textAlign: TextAlign.center,),
                        SizedBox(height: responsive.hp(2),),
                        Text('${pedidoProvider.request.vchNombreFinal}',style: TextStyle(fontSize: responsive.ip(2.0)),textAlign: TextAlign.center,),
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
                          trailing: IconButton(
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
                          )
                        )
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
                              Navigator.of(context).pushReplacementNamed(AppRoute.requestDriverScreen);
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
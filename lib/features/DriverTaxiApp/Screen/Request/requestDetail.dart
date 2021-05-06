import 'dart:io' show Platform;
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/map_network/map_network.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/Model/direction_model.dart';

class RequestDetail extends StatefulWidget {
  final Request requestItem;

  RequestDetail({this.requestItem});

  @override
  _RequestDetailState createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  final GlobalKey<FormState> formKey =GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey =GlobalKey<ScaffoldState>();
  String yourReview;
  double ratingScore;
  final requestApi = PickupApi();
  var apis = MapNetwork();
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  List<Routes> routesData;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool checkPlatform = Platform.isIOS;
  String distance, duration;

  Future<double> calcularDistancia(Request requestActual)async{
    return await Geolocator.distanceBetween(double.parse(requestActual.vchLatInicial), double.parse(requestActual.vchLongInicial), double.parse(requestActual.vchLatFinal), double.parse(requestActual.vchLongFinal))/1000;
  }
  void _onMapCreated(_) {}

  void getRouter() async {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    polyLines.clear();
    var router;
    LatLng _fromLocation = LatLng(double.parse(widget.requestItem.vchLatInicial), double.parse(widget.requestItem.vchLongInicial));
    LatLng _toLocation = LatLng(double.parse(widget.requestItem.vchLatFinal), double.parse(widget.requestItem.vchLongFinal));

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
    );
    setState(() {});
  }
  void addMakers(){
    checkPlatform ? print('ios'): print('android');
    final MarkerId markerIdFrom = MarkerId('from_address');
    final MarkerId markerIdTo = MarkerId('to_address');

    final Marker marker = Marker(
      markerId: markerIdFrom,
      position: LatLng(double.parse(widget.requestItem.vchLatInicial), double.parse(widget.requestItem.vchLongInicial)),
      infoWindow: InfoWindow(title: widget.requestItem.vchNombreInicial, snippet: 'Inicio'),
      // ignore: deprecated_member_use
      icon:  checkPlatform ? BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_48.png') : BitmapDescriptor.fromAsset('assets/image/marker/ic_dropoff_96.png'),
      onTap: () {
      },
    );

    final Marker markerTo = Marker(
      markerId: markerIdTo,
      position: LatLng(double.parse(widget.requestItem.vchLatFinal), double.parse(widget.requestItem.vchLongFinal)),
      infoWindow: InfoWindow(title: widget.requestItem.vchNombreFinal, snippet: 'Destino'),
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
  void acceptTravel(Request request) async {
    try{
      final _prefs = UserPreferences();
      await _prefs.initPrefs();
      Dialogs.openLoadingDialog(context);
      final dato = await requestApi.actionTravel(
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
        '1',
        _prefs.tokenPush
      );
      PushMessage pushMessage = getIt<PushMessage>();
      Map<String, String> data = {
        'newOffer' : '1'
      };
      Navigator.pop(context);
      if(!dato){
        Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
        return;
      }
      pushMessage.sendPushMessage(token: request.token, title: 'Oferta de conductor', description: 'Nueva oferta de conductor', data: data);
      Navigator.pop(context, true);
      
    }on ServerException catch(e){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: e.message);
    }
  }
  @override
  void initState() {
    super.initState();
    addMakers();
    getRouter();
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de pedidos', style: TextStyle(color: blackColor),
        ),
        backgroundColor: whiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: blackColor),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 10.0,right: 10.0),
        child: ButtonTheme(
          minWidth: screenSize.width ,
          height: 45.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: primaryColor,
            child: Text('Aceptar solicitud'.toUpperCase(),style: headingWhite,
            ),
            onPressed: (){
              acceptTravel(widget.requestItem);
            }
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
          child: Container(
            color: greyColor,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CachedNetworkImage(
                            imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                            fit: BoxFit.cover,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.requestItem.vchNombres ?? '',style: textBoldBlack,),
                            Text(widget.requestItem.dFecReg, style: textGrey,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('S/.${double.parse(widget.requestItem.mPrecio).toStringAsFixed(2)}',style: textBoldBlack,),
                            FutureBuilder<double>(
                            future: calcularDistancia(widget.requestItem),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return Text('${snapshot.data.toStringAsPrecision(1)} Km',style: textGrey,);
                              }else{
                                return CircularProgressIndicator();
                              }
                            }
                          ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: whiteColor,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Recoger'.toUpperCase(),style: textGreyBold,),
                              Text(widget.requestItem.vchNombreInicial,style: textStyle,),

                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Destino'.toUpperCase(),style: textGreyBold,),
                              Text(widget.requestItem.vchNombreFinal,style: textStyle,),

                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('note'.toUpperCase(),style: textGreyBold,),
                              Text(widget.requestItem.comentario,style: textStyle,),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(
                  height: responsive.hp(30),
                  child: GoogleMap(
                    padding: EdgeInsets.all(0),
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(widget.requestItem.vchLatFinal), double.parse(widget.requestItem.vchLongFinal)),
                      zoom: 13,
                    ),
                    markers: Set<Marker>.of( markers.values),
                    polylines: Set<Polyline>.of(polyLines.values),
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                  padding: EdgeInsets.all(10),
                  color: whiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Detalle de facturación)'.toUpperCase(), style: textGreyBold,),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Text('Tarifa de taxi', style: textStyle,),
                           Text('S/.${double.parse(widget.requestItem.mPrecio).toStringAsFixed(2)}', style: textBoldBlack,),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Text('Impuestos', style: textStyle,),
                           Text('S/.0.00', style: textBoldBlack,),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Text('Descuento', style: textStyle,),
                           Text('- S/.0.00', style: textBoldBlack,),
                          ],
                        ),
                      ),
                      Container(
                        width: screenSize.width - 50.0,
                        height: 1.0,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Text('Ganancia total', style: textStyleHeading18Black,),
                           Text('S/.${double.parse(widget.requestItem.mPrecio).toStringAsFixed(2)}', style: textStyleHeading18Black,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: whiteColor,
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        onPressed: ()async{
                          Dialogs.openLoadingDialog(context);
                          final _prefs = UserPreferences();
                          await _prefs.initPrefs();
                          await requestApi.actionTravel(_prefs.idChofer,widget.requestItem.id,
                            double.parse(widget.requestItem.vchLatInicial),
                            double.parse(widget.requestItem.vchLatFinal),
                            double.parse(widget.requestItem.vchLongInicial),
                            double.parse(widget.requestItem.vchLongFinal),
                            '',
                            (double.parse(widget.requestItem.mPrecio) + 0.5),
                            widget.requestItem.iTipoViaje,
                            '','','',
                            widget.requestItem.vchNombreInicial,
                            widget.requestItem.vchNombreFinal,
                            '1',
                            _prefs.tokenPush
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, 
                        child: Text('${double.parse(widget.requestItem.mPrecio) + 0.5}', style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.2)),),
                        color: primaryColor,
                        padding: EdgeInsets.all(responsive.wp(3)),
                      ),
                      FlatButton(
                        onPressed: ()async{
                          Dialogs.openLoadingDialog(context);
                          final _prefs = UserPreferences();
                          await _prefs.initPrefs();
                          await requestApi.actionTravel(_prefs.idChofer,widget.requestItem.id,
                            double.parse(widget.requestItem.vchLatInicial),
                            double.parse(widget.requestItem.vchLatFinal),
                            double.parse(widget.requestItem.vchLongInicial),
                            double.parse(widget.requestItem.vchLongFinal),
                            '',
                            (double.parse(widget.requestItem.mPrecio) + 1.0),
                            widget.requestItem.iTipoViaje,
                            '','','',
                            widget.requestItem.vchNombreInicial,
                            widget.requestItem.vchNombreFinal,
                            '1',
                            _prefs.tokenPush
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, 
                        child: Text('${double.parse(widget.requestItem.mPrecio) + 1.0}',style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.2))),
                        color: primaryColor,
                        padding: EdgeInsets.all(responsive.wp(3)),
                      ),
                      FlatButton(
                        onPressed: ()async{
                          Dialogs.openLoadingDialog(context);
                          final _prefs = UserPreferences();
                          await _prefs.initPrefs();
                          await requestApi.actionTravel(_prefs.idChofer,widget.requestItem.id,
                            double.parse(widget.requestItem.vchLatInicial),
                            double.parse(widget.requestItem.vchLatFinal),
                            double.parse(widget.requestItem.vchLongInicial),
                            double.parse(widget.requestItem.vchLongFinal),
                            '',
                            (double.parse(widget.requestItem.mPrecio) + 1.5),
                            widget.requestItem.iTipoViaje,
                            '','','',
                            widget.requestItem.vchNombreInicial,
                            widget.requestItem.vchNombreFinal,
                            '1',
                            _prefs.tokenPush
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, 
                        child: Text('${double.parse(widget.requestItem.mPrecio) + 1.5}',style: TextStyle(color: Colors.white, fontSize: responsive.ip(2.2))),
                        color: primaryColor,
                        padding: EdgeInsets.all(responsive.wp(3)),

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/core/push_message/push_notification.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/app_services_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/interprovincial_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/taxi_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/travelDriver_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Request/interprovincial_page.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'requestDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RequestDriverScreen extends StatefulWidget {
  @override
  _RequestDriverScreenState createState() => _RequestDriverScreenState();
}

class _RequestDriverScreenState extends State<RequestDriverScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final String screenName = 'REQUEST';
  List<RequestModel> requestTaxi = [];
  List<Map> requestPast = [];
  final pickupApi = PickupApi();
  final aceptar = '1';
  final rechazar = '4';
  var aceptados = <String>[];
  var rechazados = <String>[];
  String choferId = '';
  bool newTravel = false;
  String lastUserToken;
  PushNotificationProvider pushProvider;
  List<String> acceptedTravels = [];
  AppServicesProvider appServicesProvider;
  
  void navigateToDetail(RequestModel requestItem) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetail(requestItem: requestItem,)));
  }
  @override
  void initState() {
    pushProvider = PushNotificationProvider();
    pushProvider.mensajes.listen((argumento) async{
      Map data = argumento['data'];
      if(data == null) return;
      String newRequest = data['newRequest'] ?? '0';
      String newCancelSol = data['newCancelSol'] ?? '0';
      String newConfirm = data['newConfirm'] ?? '0';
      String idSolicitud = data['idSolicitud'] ?? '0';
      if (!mounted) return;
      if(newRequest == '1'){
        final _prefs = UserPreferences();
        _prefs.setNotificacionConductor = 'Solicitudes,Tiene una nueva solicitud';
        await loadRequests();
        analizeChanges(); 
      }
      if(newCancelSol == '1'){
        final _prefs = UserPreferences();
        _prefs.setNotificacionConductor = 'Solicitudes,El usuario canceló la solicitud';
        await loadRequests();
        analizeChanges(); 
      }
      if(newConfirm == '1'){
        final _prefs = UserPreferences();
        _prefs.setNotificacionConductor = 'Viajes,Haz iniciado un nuevo viaje';
        await travelConfirmation(idSolicitud);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await loadRequests();
      requestPast = requestTaxi.map((e) => {
        'id': e.id,
        'precio': e.mPrecio,
        'precioOferta': e.mPrecio
      }).toList();
      if(mounted){
        setState(() {});
      } 
    });
    super.initState();
  }
  Future<void> travelConfirmation(String idSolicitud) async {
    final _prefs = UserPreferences();
    DriverFirestoreService driverFirestoreService = DriverFirestoreService();
    String id = _prefs.idChofer;
    await driverFirestoreService.updateDriverAvalability(false, id);
    final data = await pickupApi.solicitudesUsuarioChofer(idSolicitud, _prefs.idChofer);
    _prefs.taxiRequestInCourse = requestItemToJson(data);
    _prefs.isDriverInService = true;
    final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
    // pedidoProvider.request = Request(id: data.id, iIdUsuario: data.iIdUsuario,dFecReg: '',iTipoViaje: data.iTipoViaje,mPrecio: data.mPrecio,vchDni: data.vchDni,vchCelular: data.vchCelular,vchCorreo: data.vchCorreo,vchLatInicial: data.vchLatInicial,vchLatFinal: data.vchLatFinal,vchLongInicial: data.vchLongInicial,vchLongFinal: data.vchLongFinal,vchNombreInicial: data.vchNombreInicial,vchNombreFinal: data.vchNombreFinal,vchNombres: data.vchNombres,idSolicitud: data.idSolicitud);
    pedidoProvider.request = data;
    final position = await Geolocator.getCurrentPosition();
    final currentLocation = LatLng(position.latitude, position.longitude);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TravelDriverScreen(currentLocation)), (route) => false);
  }
  Future<void> loadRequests() async {
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
        requestPast = requestTaxi.map((e) => {
          'id': e.id,
          'precio' : e.mPrecio,
          'precioOferta': e.mPrecio
        }).toList();
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
      'precio': e.mPrecio,
      'precioOferta': e.mPrecio
    }).toList();
    if(mounted){
      setState(() {});  
    }
  }
  @override
  Widget build(BuildContext context) {
    appServicesProvider = Provider.of<AppServicesProvider>(context);
    return DefaultTabController(
      length: appServicesProvider.countServices(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Solicitudes',
            style: TextStyle(color: blackColor),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: blackColor),
          bottom: TabBar(
            indicatorColor: primaryColor,
            tabs: loadTabs()),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer: MenuDriverScreens(activeScreenName: screenName),
        body: TabBarView(
          children: loadServices()
        )
      )
    );
  }
  List<Tab> loadTabs(){
    List<Tab> tabs = [];
    if(appServicesProvider.taxiAvailable){
      tabs.add(Tab(text: 'TAXI'));
    }
    if(appServicesProvider.interprovincialAvailable){
      tabs.add(Tab(text: 'INTERPROVINCIAL'));
    }
    if(appServicesProvider.heavyLoadAvailable){
      tabs.add(Tab(text: 'CARGA'));
    }
    return tabs;
  }
  List<Widget> loadServices(){
    List<Widget> services = [];
    if(appServicesProvider.taxiAvailable){
      services.add(
        Container(
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: requestTaxi.length,
              itemBuilder: (BuildContext context, int index) {
                RequestModel request = requestTaxi[index];
                TaxiModel taxiModel = TaxiModel(
                  accepteds: request.aceptados,
                  dni: request.vchDni,
                  email: request.vchCorreo,
                  finalLat: double.parse(request.vchLatFinal),
                  finalLong: double.parse(request.vchLongFinal),
                  finalname: request.vchNombreFinal,
                  id: request.id,
                  initialLat: double.parse(request.vchLatInicial),
                  initialLong: double.parse(request.vchLongInicial),
                  names: request.vchNombres,
                  phone: request.vchCelular,
                  price: double.parse(request.mPrecio),
                  queryId: request.idSolicitud,
                  registeredAt: DateTime.now(),
                  // registeredAt: DateTime.parse(request.dFecReg),
                  rejecteds: request.rechazados,
                  startName: request.vchNombreInicial,
                  typeTravel: request.iTipoViaje,
                  userId: request.iIdUsuario,
                  comentario: request.comentario,
                  token: request.token,
                  userPhoto: request.urlUser
                );
                return GestureDetector(
                  onTap: () {
                    navigateToDetail(request);
                  },
                  child: cardTaxi(taxiModel)
                );
              }
            ),
          )
        ),
      );
    }
    if(appServicesProvider.interprovincialAvailable){
      services.add(
        Container(
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    navigateToDetail(requestTaxi[index]);
                  },
                  child: cardInterprovincial(InterprovincialModel.empty())
                );
              }
            ),
          )
        )
      );
    }
    if(appServicesProvider.heavyLoadAvailable){
      services.add(
        Container(
          child: Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    navigateToDetail(requestTaxi[index]);
                  },
                  child: historyItemCarga()
                );
              }
            ),
          )
        ),
      );
    }
    return services;
  }
  Widget cardTaxi(TaxiModel taxi){
    final responsive = Responsive(context);
    Map requestActual = requestPast.where((element) => element['id'] == taxi.id).toList().first;
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
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
                      borderRadius: BorderRadius.circular(50),
                      child: taxi.userPhoto != null && taxi.userPhoto.isNotEmpty ?  CachedNetworkImage(
                        imageUrl: taxi.userPhoto,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ) : Image.asset(
                        'assets/image/empty_user_photo.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(taxi.names,style: textBoldBlack,),
                        Text(taxi.phone, style: textGrey,),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('S/.${taxi.price.toStringAsFixed(2)}',style: textBoldBlack,),
                        FutureBuilder<double>(
                          future: taxi.calculateDistance,
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return Text('${snapshot.data.toStringAsFixed(2)} Km',style: textGrey,);
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
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Recoger'.toUpperCase(),style: textGreyBold,),
                        Text(taxi.startName,style: textStyle,),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Destino'.toUpperCase(),style: textGreyBold,),
                        Text(taxi.finalname, style: textStyle,),

                      ],
                    ),
                  ),
                  Divider(),
                  taxi.comentario.isNotEmpty ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Comentario'.toUpperCase(),style: textGreyBold,),
                        Text(taxi.comentario,style: textStyle,),

                      ],
                    ),
                  ) : Container(),
                ],
              )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    shape:RoundedRectangleBorder(
                      borderRadius:
                        BorderRadius.circular(10.0),
                    ),
                    onPressed: (){
                      double price = double.parse(requestActual['precioOferta']);
                      price-=0.5;
                      requestActual['precioOferta']=price.toStringAsFixed(2);
                      setState(() {});
                    },
                    child: Text('-0.5', style: TextStyle(color:Colors.grey)),
                  ),
                  Text('S/${double.parse(requestActual['precioOferta']).toStringAsFixed(2)}',style: TextStyle(fontSize: responsive.ip(2.2), fontWeight: FontWeight.w600),),
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: (){
                      double price = double.parse(requestActual['precioOferta']);
                      price+=0.5;
                      requestActual['precioOferta']=price.toStringAsFixed(2);
                      setState(() {});
                      // pedidoProvider.incrementarPrecio();
                    },
                    child: Text('+0.5',style: TextStyle(color: primaryColor),),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width - 50.0,
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  elevation: 0.0,
                  color: Colors.blue.withOpacity(0.8),
                  child: Text('Modificar precio',style: headingWhite,
                  ),
                  onPressed: () async{
                    try{
                      final _prefs = UserPreferences();
                      await _prefs.initPrefs();
                      newTravel = true;
                      Dialogs.openLoadingDialog(context);
                      final dato = await pickupApi.actionTravel(
                        _prefs.idChofer,
                        taxi.id,
                        taxi.initialLat,
                        taxi.finalLat,
                        taxi.initialLong,
                        taxi.finalLong,
                        '',
                        double.parse(requestActual['precioOferta']),
                        taxi.typeTravel,
                        '', '', '',
                        taxi.startName,
                        taxi.finalname,
                        aceptar,
                        _prefs.tokenPush
                      );
                      acceptedTravels.add(taxi.id);
                      PushMessage pushMessage = getIt<PushMessage>();
                      Map<String, String> data = {
                        'newOffer' : '1'
                      };
                      lastUserToken = taxi.token;
                      pushMessage.sendPushMessage(token: taxi.token, title: 'Oferta de conductor', description: 'Nueva oferta de conductor', data: data);
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
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ButtonTheme(
                      height: 45,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                        color: Colors.redAccent,
                        child: Text('Rechazar',style: headingWhite,
                        ),
                        onPressed: ()async{
                          try{
                            final _prefs = UserPreferences();
                            await _prefs.initPrefs();
                            Dialogs.openLoadingDialog(context);
                            final dato = await pickupApi.actionTravel(
                              _prefs.idChofer,
                              taxi.id,
                              taxi.initialLat,
                              taxi.finalLat,
                              taxi.initialLong,
                              taxi.finalLong, '',
                              taxi.price,
                              taxi.typeTravel,
                              '', '', '',
                              taxi.startName,
                              taxi.finalname,
                              rechazar,
                              _prefs.tokenPush
                            );
                            if(acceptedTravels.contains(taxi.id)){
                              PushMessage pushMessage = getIt<PushMessage>();
                              Map<String, String> data = {
                                'newReffuse' : '1',
                                'idChofer': _prefs.idChoferReal
                              };
                              lastUserToken = taxi.token;
                              pushMessage.sendPushMessage(token: taxi.token, title: 'Cancelación de oferta', description: 'El conductor canceló la oferta', data: data);
                            }
                            await loadRequests();
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
                          //navigateToDetail(requestActual);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ButtonTheme(
                      height: 45,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                        color: primaryColor,
                        child: Text('Aceptar',style: headingWhite,
                        ),
                        onPressed: ()async{
                          try{
                            final _prefs = UserPreferences();
                            await _prefs.initPrefs();
                            newTravel = true;
                            Dialogs.openLoadingDialog(context);
                            final dato = await pickupApi.actionTravel(
                              _prefs.idChofer,
                              taxi.id,
                              taxi.initialLat,
                              taxi.finalLat,
                              taxi.initialLong,
                              taxi.finalLong,
                              '',
                              taxi.price,
                              taxi.typeTravel,
                              '', '', '',
                              taxi.startName,
                              taxi.finalname,
                              aceptar,
                              _prefs.tokenPush
                            );
                            acceptedTravels.add(taxi.id);
                            PushMessage pushMessage = getIt<PushMessage>();
                            Map<String, String> data = {
                              'newOffer' : '1'
                            };
                            lastUserToken = taxi.token;
                            pushMessage.sendPushMessage(token: taxi.token, title: 'Oferta de conductor', description: 'Nueva oferta de conductor', data: data);
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
  }

  Widget cardInterprovincial(InterprovincialModel interprovincial) {
    final screenSize = MediaQuery.of(context).size;
    return Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
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
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: interprovincial.userUrlPhoto,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(interprovincial.userNames,style: textBoldBlack),
                          Text(interprovincial.registeredAt.fullFormatToCard, style: textGrey),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Chip(
                                  backgroundColor: primaryColor,
                                  padding: EdgeInsets.all(5),
                                  label: Text('Crédito',style: textBoldWhite,),
                                ),
                                SizedBox(width: 10),
                                Chip(
                                  backgroundColor: primaryColor,
                                  padding: EdgeInsets.all(5),
                                  label: Text('Descuento',style: textBoldWhite,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('S/. ' + interprovincial.price.toStringAsFixed(2),style: textBoldBlack,),
                          Text('160.2 Km',style: textGrey,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Recoger'.toUpperCase(),style: textGreyBold,),
                          Text(interprovincial.currentAddress,style: textStyle,),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Destino'.toUpperCase(),style: textGreyBold,),
                          Text(interprovincial.destination, style: textStyle,),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ButtonTheme(
                  minWidth: screenSize.width ,
                  height: 45,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    elevation: 0,
                    color: primaryColor,
                    child: Text('Aceptar',style: headingWhite.copyWith(fontSize: 16)),
                    onPressed: () => navigateToInterprovincial(interprovincial)
                  ),
                ),
              ),

            ],
          ),
        ),
      );
  }

  void navigateToInterprovincial(InterprovincialModel interprovincial) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => InterprovincialPage(interprovincial: interprovincial)));
  }

  Widget historyItemCarga() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  'https://source.unsplash.com/300x300/?portrait',
                )
              ),
              title: Text('Manuel Juarez'),
              subtitle: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                    Icon(Icons.calendar_today,size: 9,),
                    SizedBox(width: 4,),
                    Text('21 ago.,22:58',style: TextStyle(fontSize: 9),)
                  ],),
                  Row(
                    children: <Widget>[
                      Icon(Icons.arrow_forward,size: 12,),
                      SizedBox(width: 2,),
                      Text('clinica Sanna Sanchez Ferrer',style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back,size: 12,),
                      SizedBox(width: 2,),
                      Text('Vista Alegre Sanchez Carrion 305',style: TextStyle(fontSize: 12),),
                    ],
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('S/6', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),)
                ],
              ),
        ),
        Container(
          margin: EdgeInsets.only(left: 70),
          child: Text('6 mesas chicas, 20 sillas y un frio y tres citrinas chiquitas'),
        )
      ],
    );
  }
}

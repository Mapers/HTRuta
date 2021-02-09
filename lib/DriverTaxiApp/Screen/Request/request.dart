import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/dialogs.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/exceptions.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:flutter_map_booking/DriverTaxiApp/Model/request_model.dart';
import 'package:flutter_map_booking/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:flutter_map_booking/DriverTaxiApp/theme/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import '../../../app_router.dart';
import 'requestDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RequestDriverScreen extends StatefulWidget {
  @override
  _RequestDriverScreenState createState() => _RequestDriverScreenState();
}

class _RequestDriverScreenState extends State<RequestDriverScreen> {
  final String screenName = "REQUEST";
  Channel _channel;
  List<Request> requestTaxi = List<Request>();
  final pickupApi = PickupApi();
  final aceptar = '1';
  final rechazar = '2';
  var aceptados = List<String>();
  var rechazados = List<String>();
  String choferId = '';
  final Geolocator _locationService = Geolocator();

  navigateToDetail(Request requestItem) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetail(requestItem: requestItem,)));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final _prefs = PreferenciaUsuario();
      await _prefs.initPrefs();
      final data = await pickupApi.getRequest();
      print(_prefs.idChofer);
      if(data != null){
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
        setState(() {
          
        });
      }
      await initPusher();
    });
    super.initState();
  }

  Future<void> initPusher()async{ 
    try{
      await Pusher.init('4b1d6dd1d636f15f0e59', PusherOptions(cluster: 'us2'));
    }catch(e){
      print(e);
    }

    final _prefs = PreferenciaUsuario();
    await _prefs.initPrefs();
    choferId = _prefs.idChofer;
    print(choferId);

    Pusher.connect(
      onConnectionStateChange: (val) {
          print(val.currentState);
      },
      onError: (error){
        
      }
    );

    _channel = await Pusher.subscribe('solicitud');

    _channel.bind('SendSolicitud', (onEvent) {
      requestTaxi.clear();
      aceptados.clear();
      rechazados.clear();
      requestTaxi.addAll(requestFromJson(onEvent.data));
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

      setState(() {
        
      });
    });


    _channel.bind('SendSolicitudUsuarioChofer${_prefs.idChofer}', (onEvent){
      final data = json.decode(onEvent.data);
      final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
      pedidoProvider.request = Request(id: data[0]['iIdViaje'],iIdUsuario: data[0]['iIdUsuario'],dFecReg: '',iTipoViaje: data[0]['iTipoViaje'],mPrecio: data[0]['mPrecio'],vchDni: data[0]['dni'],vchCelular: data[0]['celular'],vchCorreo: data[0]['correo'],vchLatInicial: data[0]['vchLatInicial'],vchLatFinal: data[0]['vchLatFinal'],vchLongInicial: data[0]['vchLongInicial'],vchLongFinal: data[0]['vchLongFinal'],vchNombreInicial: data[0]['vchNombreInicial'],vchNombreFinal: data[0]['vchNombreFinal'],vchNombres: data[0]['vchNombres'],idSolicitud: data[0]['IdSolicitud']);
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.travelDriverScreen, (route) => false);
     });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Solicitudes',
            style: TextStyle(color: blackColor),
          ),
          elevation: 2.0,
          iconTheme: IconThemeData(color: blackColor),
          bottom: TabBar(tabs: [
            Tab(child: Text('TAXI', style: TextStyle(color: Colors.white,fontSize: 11),),),
            Tab(child: Text('INTERPROVINCIAL', style: TextStyle(color: Colors.white,fontSize: 10),)),
            Tab(child: Text('CARGA', style: TextStyle(color: Colors.white,fontSize: 11),))
          ]),
        ),
        drawer: new MenuDriverScreens(activeScreenName: screenName),
        body: TabBarView(
          children: [
            Container(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestTaxi.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print('$index');
                        navigateToDetail(requestTaxi[index]);
                      },
                      child: historyItem(index)
                    );
                  }
                ),
              )
            ),
            Container(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print('$index');
                        navigateToDetail(requestTaxi[index]);
                      },
                      child: historyItem2()
                    );
                  }
                ),
              )
            ),
            Container(
              child: Scrollbar(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print('$index');
                        navigateToDetail(requestTaxi[index]);
                      },
                      child: historyItemCarga()
                    );
                  }
                ),
              )
            ),
          ]
        )
      ),
    );
  }

  // bool esRechazadoAceptado(String aceptados, String rechazados){
  //   bool respuesta = false;
  //   if(aceptados != null){
  //     aceptados.split(',').forEach((element) {
  //       if(element == choferId){
  //         respuesta = true;
  //         return;
  //       }
  //     });
  //     return respuesta;
  //   }else if(rechazados != null){
  //     rechazados.split(',').forEach((element) {
  //       if(element == choferId){
  //         respuesta = true;
  //         return;
  //       }
  //     });
  //     return respuesta;
  //   }else{
  //     return respuesta;
  //   }
  // }

  Future<double> calcularDistancia(Request requestActual)async{
    return await _locationService.distanceBetween(double.parse(requestActual.vchLatInicial), double.parse(requestActual.vchLongInicial), double.parse(requestActual.vchLatFinal), double.parse(requestActual.vchLongFinal))/1000;
  }

  Widget historyItem(int index) {
    final screenSize = MediaQuery.of(context).size;
    final requestActual = requestTaxi[index];

    

    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
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
                          Text(requestActual.vchNombres,style: textBoldBlack,),
                          Text(requestActual.dFecReg, style: textGrey,),
                          // Container(
                          //   child: Row(
                          //     children: <Widget>[
                          //       Container(
                          //         height: 25.0,
                          //         padding: EdgeInsets.all(5.0),
                          //         alignment: Alignment.center,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10.0),
                          //           color: primaryColor
                          //         ),
                          //         child: Text('ApplePay',style: textBoldWhite,),
                          //       ),
                          //       SizedBox(width: 10),
                          //       Container(
                          //         height: 25.0,
                          //         padding: EdgeInsets.all(5.0),
                          //         alignment: Alignment.center,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(10.0),
                          //             color: primaryColor
                          //         ),
                          //         child: Text('Descuento',style: textBoldWhite,),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("S/.${double.parse(requestActual.mPrecio).toStringAsFixed(2)}",style: textBoldBlack,),
                          FutureBuilder<double>(
                            future: calcularDistancia(requestActual),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return Text("${snapshot.data.toStringAsPrecision(1)} Km",style: textGrey,);
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
                          Text("Recoger".toUpperCase(),style: textGreyBold,),
                          Text(requestActual.vchNombreInicial,style: textStyle,),

                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Destino".toUpperCase(),style: textGreyBold,),
                          Text(requestActual.vchNombreFinal,style: textStyle,),

                        ],
                      ),
                    ),
                  ],
                )
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
                              final _prefs = PreferenciaUsuario();
                              await _prefs.initPrefs();
                              Dialogs.openLoadingDialog(context);
                              final dato = await pickupApi.actionTravel(_prefs.idChofer,requestActual.id, requestActual.vchLatInicial, requestActual.vchLatFinal, requestActual.vchLongInicial, requestActual.vchLongFinal, '', requestActual.mPrecio, requestActual.iTipoViaje, '', '', '',requestActual.vchNombreInicial,requestActual.vchNombreFinal, rechazar);
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
                              final _prefs = PreferenciaUsuario();
                              await _prefs.initPrefs();
                              Dialogs.openLoadingDialog(context);
                              final dato = await pickupApi.actionTravel(_prefs.idChofer,requestActual.id, requestActual.vchLatInicial, requestActual.vchLatFinal, requestActual.vchLongInicial, requestActual.vchLongFinal, '', requestActual.mPrecio, requestActual.iTipoViaje, '', '', '',requestActual.vchNombreInicial,requestActual.vchNombreFinal, aceptar);
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

  Widget historyItem2() {
    final screenSize = MediaQuery.of(context).size;
    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
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
                          Text('Moises Alcantara',style: textBoldBlack,),
                          Text("21 Ago 2020 12:00 PM", style: textGrey,),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: primaryColor
                                  ),
                                  child: Text('Crédito',style: textBoldWhite,),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: primaryColor
                                  ),
                                  child: Text('Descuento',style: textBoldWhite,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text("S/.250.0",style: textBoldBlack,),
                          Text("160.2 Km",style: textGrey,),
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
                          Text("Recoger".toUpperCase(),style: textGreyBold,),
                          Text("Av. America 345, Trujillo",style: textStyle,),

                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Destino".toUpperCase(),style: textGreyBold,),
                          Text("Chiclayo",style: textStyle,),

                        ],
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ButtonTheme(
                  minWidth: screenSize.width ,
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                    elevation: 0.0,
                    color: primaryColor,
                    child: Text('Aceptar',style: headingWhite,
                    ),
                    onPressed: (){
//                      Navigator.of(context).pushReplacementNamed('/history');
                      navigateToDetail(requestTaxi[0]);
                    },
                  ),
                ),
              ),

            ],
          ),
        ),
      );
  }

  Widget historyItemCarga() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  "https://source.unsplash.com/300x300/?portrait",
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

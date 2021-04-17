import 'dart:convert';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/interprovincial_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/taxi_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Request/interprovincial_page.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:provider/provider.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../../../../app_router.dart';
import 'requestDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RequestDriverScreen extends StatefulWidget {
  @override
  _RequestDriverScreenState createState() => _RequestDriverScreenState();
}

class _RequestDriverScreenState extends State<RequestDriverScreen> {
  final String screenName = 'REQUEST';
  Channel _channel;
  List<Request> requestTaxi = [];
  final pickupApi = PickupApi();
  final aceptar = '1';
  final rechazar = '2';
  var aceptados = <String>[];
  var rechazados = <String>[];
  String choferId = '';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  void navigateToDetail(Request requestItem) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetail(requestItem: requestItem,)));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final _prefs = UserPreferences();
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

    final _prefs = UserPreferences();
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
      setState(() {});
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
      child: SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuDriverScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Solicitudes',
            style: TextStyle(color: blackColor),
          ),
          elevation: 2,
          iconTheme: IconThemeData(color: blackColor),
          bottom: TabBar(tabs: [
            Tab(child: Text('TAXI', style: TextStyle(color: Colors.white,fontSize: 11),),),
            Tab(child: Text('INTERPROVINCIAL', style: TextStyle(color: Colors.white,fontSize: 10),)),
            Tab(child: Text('CARGA', style: TextStyle(color: Colors.white,fontSize: 11),))
          ]),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              final _state = _sideMenuKey.currentState;
              if (_state.isOpened)
                _state.closeSideMenu(); // close side menu
              else
                _state.openSideMenu();// open side menu
            },
          ),
        ),
        drawer: MenuDriverScreens(activeScreenName: screenName),
        body: TabBarView(
          children: [
            Container(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestTaxi.length,
                  itemBuilder: (BuildContext context, int index) {
                    Request request = requestTaxi[index];
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
                      comentario: request.comentario
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
                      child: cardInterprovincial(InterprovincialModel.empty())
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
    )
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

  Widget cardTaxi(TaxiModel taxi){
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
                        imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
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
                        Text(taxi.names,style: textBoldBlack,),
                        Text(taxi.registeredAt.toString(), style: textGrey,),
                        // Container(
                        //   child: Row(
                        //     children: <Widget>[
                        //       Container(
                        //         height: 25,
                        //         padding: EdgeInsets.all(5),
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: primaryColor
                        //         ),
                        //         child: Text('ApplePay',style: textBoldWhite,),
                        //       ),
                        //       SizedBox(width: 10),
                        //       Container(
                        //         height: 25,
                        //         padding: EdgeInsets.all(5),
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
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
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Comentario'.toUpperCase(),style: textGreyBold,),
                          Text(taxi.comentario,style: textStyle,),

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
                              rechazar
                            );
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
                              aceptar
                            );
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

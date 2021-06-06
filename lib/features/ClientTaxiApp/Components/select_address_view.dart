import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/payment_selector.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/register_travel_body.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/direction_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  final Place fromAddress,toAddress;
  final VoidCallback onTap;
  final int distancia;
  final String unidad;
  SelectAddress({
    this.fromAddress,
    this.toAddress,
    this.onTap,
    this.distancia,
    this.unidad
  });

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  String selectedAddress;
  String precio = '';
  String comentarios = '';
  FocusNode precioFocus = FocusNode();
  final pickUpApi = PickupApi();
  List<int> paymentMethodsSelected = [];
  final _prefs = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.my_location),
                      Container(
                        height: 40,
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      Icon(Icons.location_on,color: redColor,)
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Recoger',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey
                                ),
                              ),
                              Text(
                                widget.fromAddress != null ? widget.fromAddress.name : 'Recoger',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                        child: Divider(color: Colors.grey,)
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Dejar',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey
                                ),
                              ),
                              Text(
                                widget.toAddress != null ? widget.toAddress.name : 'Dirigirse',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 60),
              child: Divider(color: Colors.grey,)
            ),
            Padding(
              padding: EdgeInsets.only(left: 45),
              child: PaymentSelector(
                onSelected: (List<int> selectedPaymentMethods){
                  paymentMethodsSelected = selectedPaymentMethods;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 60),
              child: Divider(color: Colors.grey,)
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Text('S/', style: TextStyle(fontSize: 18),),
                    SizedBox(width: 15,),
                    Expanded(
                      child: TextFormField(
                        focusNode: precioFocus,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState(() {
                            precio = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15.0, bottom: 10),
                          hintText: 'Ofrezca su tarifa',
                          hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Quicksand'
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                  Icon(Icons.comment),
                  SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        onChanged: (value){
                          setState(() {
                            comentarios = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15.0, bottom: 10),
                          hintText: 'Comentarios y deseos',
                          hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Quicksand',
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 10,),
            Expanded(
              child: FlatButton(
                onPressed: ()async{
                  try{
                    if(widget.toAddress == null){
                      Dialogs.alert(context,title: 'Advertencia', message: 'Seleccione una posición de inicio');
                      return;
                    }
                    if(widget.toAddress.name.isEmpty){
                      Dialogs.alert(context,title: 'Advertencia', message: 'Seleccione una posición de fin');
                      return;
                    }
                    if(_prefs.getClientPaymentMethods.isEmpty){
                      Dialogs.alert(context,title: 'Advertencia', message: 'Seleccione al menos un método de pago');
                      return;
                    }
                    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
                    
                    if(precio.isNotEmpty){
                      final _session = Session();
                      final dataUsuario = await _session.get();
                      Dialogs.openLoadingDialog(context);
                      
                      String token = _prefs.tokenPush;
                      RegisterTravelBody body = RegisterTravelBody(
                        idTokenCliente: token,
                        idusuario: int.parse(dataUsuario.id),
                        vchLatinicial:  widget.fromAddress.lat,
                        vchLatfinal: widget.toAddress.lat,
                        vchLonginicial:  widget.fromAddress.lng,
                        vchLongfinal: widget.toAddress.lng,
                        mPrecio: int.parse(precio),
                        iTipoViaje: 1,
                        vchNombreInicial: widget.fromAddress.name,
                        vchNombreFinal: widget.toAddress.name,
                        comentario: comentarios,
                        unidad: widget.unidad,
                        distancia: widget.distancia,
                        arrFormaPagoIds: _prefs.getClientPaymentMethods.map((e) => int.parse(e)).toList()
                      ); 
                      final viaje = await pickUpApi.registerTravelClient(body);
                      PushMessage pushMessage = getIt<PushMessage>();
                      Map<String, String> data = {
                        'newRequest' : '1'
                      };
                      _prefs.setNotificacionUsuario = 'Solicitudes,Ha realizado una nueva solicitud';
                      DriverFirestoreService driverFirestoreService = DriverFirestoreService();
                      List<String> tokens = await driverFirestoreService.getDrivers();
                      pushMessage.sendPushMessageBroad(tokens: tokens, title: 'Solicitud de viaje', description: 'Nueva o actualización de solicitud', data: data);
                      Navigator.pop(context);
                      if(viaje.success){
                        pedidoProvider.idSolicitud = viaje.data[0].idSolicitud;
                        pedidoProvider.request = RequestModel(id: viaje.data[0].idSolicitud,iIdUsuario: dataUsuario.id,dFecReg: '',iTipoViaje: '1',mPrecio: precio,vchDni: dataUsuario.dni,vchCelular: dataUsuario.cellphone,vchCorreo: dataUsuario.email,vchLatInicial: widget.fromAddress.lat.toString(),vchLatFinal: widget.toAddress.lat.toString(),vchLongInicial: widget.fromAddress.lng.toString(),vchLongFinal: widget.toAddress.lng.toString(),vchNombreInicial: widget.fromAddress.name.toString(),vchNombreFinal: widget.toAddress.name.toString(),vchNombres: '${dataUsuario.names} ${dataUsuario.lastNameFather} ${dataUsuario.lastNameMother}');
                        pedidoProvider.precio = double.parse(precio);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DirectionScreen())
                        );
                      }
                    }else{
                      Dialogs.alert(context,title: 'Advertencia', message: 'Debe ingresar el precio');
                    }
                  }on ServerException catch (error){
                    Navigator.pop(context);
                    Dialogs.alert(context,title: 'Error', message: error.message);
                  }
                }, 
                child: Text('Solicitar un auto', style: TextStyle(color: Colors.white,fontSize: 18),),
                color: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 80),
              )
            )
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.only(left: 10),
            //     child: NotificationListener<OverscrollIndicatorNotification>(
            //       onNotification: (overScroll) {
            //         overScroll.disallowGlow();
            //         return false;
            //       },
            //       child: getOption()
            //     )
            //   )
            // )
          ],
        ),
      ),
    );
  }
}

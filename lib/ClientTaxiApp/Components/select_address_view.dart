import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Model/place_model.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Screen/Directions/direction_screen.dart';
import 'package:flutter_map_booking/ClientTaxiApp/theme/style.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/dialogs.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/exceptions.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/session.dart';
import 'package:flutter_map_booking/DriverTaxiApp/Model/request_model.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  final Place fromAddress,toAddress;
  final VoidCallback onTap;
  SelectAddress({
    this.fromAddress,
    this.toAddress,
    this.onTap
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
//   List<Map<String, dynamic>> listAddress = [
//     {"id": 1, "title": "Trujillo"},
//     {"id": 2, "title": "La Esperanza"},
//     {"id": 3,"title": "Porvenir"},
//     {"id": 4,"title": "Alto Trujillo"},
//   ];

//   Widget getOption() {
//     return ListView.builder(
//       shrinkWrap: true,
//       scrollDirection: Axis.horizontal,
//       itemCount: listAddress.length,
//       itemBuilder: (BuildContext context,int index){
//         return Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: ChoiceChip(
//             key: ValueKey<String>(listAddress[index]['id'].toString()),
//             labelStyle: TextStyle(
//                 color: whiteColor
//             ),
//             backgroundColor: whiteColor,
//             selectedColor: primaryColor,
//             elevation: 1.0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             selected: selectedAddress == listAddress[index]['id'].toString(),
//             label: Text(listAddress[index]['title'],
//               style: TextStyle(
//                 color: selectedAddress == listAddress[index]['id'].toString() ? whiteColor : blackColor
//               ),
//             ),
//             onSelected: (bool check) {
//               widget?.onTap();
// //              setState(() {
// //                selectedAddress = check ? listAddress[index]["id"].toString() : '';
// //              });
//             })
//         );
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
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
                              Text("Recoger",
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
                              Text("Dejar",
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
                          contentPadding:
                            EdgeInsets.only(left: 15.0),
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
                          contentPadding:
                            EdgeInsets.only(left: 15.0),
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
                    final pedidoProvider = Provider.of<PedidoProvider>(context,listen: false);
                    if(precio.isNotEmpty){
                      final _session = Session();
                      final dataUsuario = await _session.get();
                      Dialogs.openLoadingDialog(context);
                      final viaje = await pickUpApi.registerTravel(dataUsuario['id'], widget.fromAddress.lat.toString(), widget.toAddress.lat.toString(),  widget.fromAddress.lng.toString(),widget.toAddress.lng.toString(),precio, '1',widget.fromAddress.name,widget.toAddress.name);
                      Navigator.pop(context);
                      if(viaje.success){
                        pedidoProvider.idSolicitud = viaje.data[0].idSolicitud;
                        pedidoProvider.request = Request(id: viaje.data[0].idSolicitud,iIdUsuario: dataUsuario['id'],dFecReg: '',iTipoViaje: '1',mPrecio: precio,vchDni: dataUsuario['dni'],vchCelular: dataUsuario['celular'],vchCorreo: dataUsuario['correo'],vchLatInicial: widget.fromAddress.lat.toString(),vchLatFinal: widget.toAddress.lat.toString(),vchLongInicial: widget.fromAddress.lng.toString(),vchLongFinal: widget.toAddress.lng.toString(),vchNombreInicial: widget.fromAddress.name.toString(),vchNombreFinal: widget.toAddress.name.toString(),vchNombres: '${dataUsuario['nombres']} ${dataUsuario['apellidoPaterno']} ${dataUsuario['apellidoMaterno']}');
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

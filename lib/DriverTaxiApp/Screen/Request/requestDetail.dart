import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:HTRuta/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/DriverTaxiApp/theme/style.dart';
import 'package:geolocator/geolocator.dart';
import 'pickUp.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RequestDetail extends StatefulWidget {
  final Request requestItem;

  RequestDetail({this.requestItem});

  @override
  _RequestDetailState createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String yourReview;
  double ratingScore;
  final Geolocator _locationService = Geolocator();
  final requestApi = PickupApi();

  Future<double> calcularDistancia(Request requestActual)async{
    return await _locationService.distanceBetween(double.parse(requestActual.vchLatInicial), double.parse(requestActual.vchLongInicial), double.parse(requestActual.vchLatFinal), double.parse(requestActual.vchLongFinal))/1000;
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
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: primaryColor,
            child: Text('Ir a recoger'.toUpperCase(),style: headingWhite,
            ),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickUp()));
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.requestItem.vchNombres,style: textBoldBlack,),
                            Text(widget.requestItem.dFecReg, style: textGrey,),
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
                                    child: Text('ApplePay',style: textBoldWhite,),
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
                            Text("S/.${double.parse(widget.requestItem.mPrecio).toStringAsFixed(2)}",style: textBoldBlack,),
                            FutureBuilder<double>(
                            future: calcularDistancia(widget.requestItem),
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
                  color: whiteColor,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Recoger".toUpperCase(),style: textGreyBold,),
                              Text(widget.requestItem.vchNombreInicial,style: textStyle,),

                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Destino".toUpperCase(),style: textGreyBold,),
                              Text(widget.requestItem.vchNombreFinal,style: textStyle,),

                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("note".toUpperCase(),style: textGreyBold,),
                              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry",style: textStyle,),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                  padding: EdgeInsets.all(10),
                  color: whiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Detalle de facturación)".toUpperCase(), style: textGreyBold,),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Tarifa de taxi", style: textStyle,),
                            new Text("S/.${double.parse(widget.requestItem.mPrecio).toStringAsFixed(2)}", style: textBoldBlack,),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Impuestos", style: textStyle,),
                            new Text("S/.0.00", style: textBoldBlack,),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Descuento", style: textStyle,),
                            new Text("- S/.0.00", style: textBoldBlack,),
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
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Ganancia total", style: heading18Black,),
                            new Text("S/.${double.parse(widget.requestItem.mPrecio).toStringAsFixed(2)}", style: heading18Black,),
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
                          final _prefs = PreferenciaUsuario();
                          await _prefs.initPrefs();
                          await requestApi.actionTravel(_prefs.idChofer,widget.requestItem.id,
                            double.parse(widget.requestItem.vchLatInicial),
                            double.parse(widget.requestItem.vchLatFinal),
                            double.parse(widget.requestItem.vchLongInicial),
                            double.parse(widget.requestItem.vchLongFinal),
                            "",
                            (double.parse(widget.requestItem.mPrecio) + 0.5),
                            widget.requestItem.iTipoViaje,
                            '','','',
                            widget.requestItem.vchNombreInicial,
                            widget.requestItem.vchNombreFinal,
                            "1"
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
                          final _prefs = PreferenciaUsuario();
                          await _prefs.initPrefs();
                          await requestApi.actionTravel(_prefs.idChofer,widget.requestItem.id,
                            double.parse(widget.requestItem.vchLatInicial),
                            double.parse(widget.requestItem.vchLatFinal),
                            double.parse(widget.requestItem.vchLongInicial),
                            double.parse(widget.requestItem.vchLongFinal),
                            "",
                            (double.parse(widget.requestItem.mPrecio) + 1.0),
                            widget.requestItem.iTipoViaje,
                            '','','',
                            widget.requestItem.vchNombreInicial,
                            widget.requestItem.vchNombreFinal,
                            "1"
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
                          final _prefs = PreferenciaUsuario();
                          await _prefs.initPrefs();
                          await requestApi.actionTravel(_prefs.idChofer,widget.requestItem.id,
                            double.parse(widget.requestItem.vchLatInicial),
                            double.parse(widget.requestItem.vchLatFinal),
                            double.parse(widget.requestItem.vchLongInicial),
                            double.parse(widget.requestItem.vchLongFinal),
                            "",
                            (double.parse(widget.requestItem.mPrecio) + 1.5),
                            widget.requestItem.iTipoViaje,
                            '','','',
                            widget.requestItem.vchNombreInicial,
                            widget.requestItem.vchNombreFinal,
                            "1"
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

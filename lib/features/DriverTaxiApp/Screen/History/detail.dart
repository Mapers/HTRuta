import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/historical_detail_response.dart';

class HistoryDetail extends StatefulWidget {
  final String id;

  HistoryDetail({this.id});

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final GlobalKey<FormState> formKey =GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey =GlobalKey<ScaffoldState>();
  String yourReview = '';
  double ratingScore;
  final pickupApi = PickupApi();
  HistoryDetailItem detailLoaded;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial',
          style: TextStyle(color: blackColor),
        ),
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 2.0,
        iconTheme: IconThemeData(color: blackColor),
      ),
      /* bottomNavigationBar: ButtonTheme(
        minWidth: screenSize.width,
        height: 45.0,
        child: RaisedButton(
          elevation: 0.0,
          color: primaryColor,
          child: Text('Enviar',style: headingWhite,
          ),
          onPressed: () async {
            /* SaveQualificationBody body = SaveQualificationBody(
              viajeId: int.parse(widget.id),
              stars: ratingScore,
              comment: yourReview
            );
            bool success = await pickupApi.sendUserQualification(body);
            if(!success){
              Dialogs.alert(context,title: 'Lo sentimos', message: 'No se pudo guardar su calificación');
              return;
            }else{
              Navigator.pop(context);
            } */  
            Navigator.pop(context);
          },
        ),
      ), */
      body: Scrollbar(
        child: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
              child: detailLoaded == null ? FutureBuilder(
                future: pickupApi.getHistoryDriverDetail(widget.id),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasError) return Container(child: Text('Ha ocurrido un error'));
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting: return Container();
                    case ConnectionState.none: return Container();
                    case ConnectionState.active: {
                      detailLoaded = snapshot.data;
                      return createContent(screenSize, detailLoaded);
                    }
                    case ConnectionState.done: {
                      detailLoaded = snapshot.data;
                      return createContent(screenSize, detailLoaded);
                    }
                  }
                  return Container();
                }
              ) : createContent(screenSize, detailLoaded)
            ),
          ),
        ),
      );
  }
  Widget createContent(Size screenSize, HistoryDetailItem detail){
    return Container(
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
                      Text('Olivia Ramos2',style: textBoldBlack,),
                      Text('${DateTimeExtension.changeDateFormat((detail.fechaRegistro.toString().substring(0, 10)))} ${detail.fechaRegistro.toString().substring(11, 16)}', style: textGrey,),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(detail.comision != null ? 'S/ ${(double.parse(detail.precio) - double.parse(detail.comision)).toStringAsFixed(2)}' : 'S/ ${(double.parse(detail.precio).toStringAsFixed(2))}',style: textBoldBlack,),
                      Text('${(double.parse(detail.distanciaMeters)/1000).toStringAsFixed(1)} km',style: textGrey,),
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
                        Text(detail.origen,style: textStyle,),

                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Destino'.toUpperCase(),style: textGreyBold,),
                        Text(detail.destino,style: textStyle,),

                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('COMENTARIO'.toUpperCase(),style: textGreyBold,),
                        Text(detail.observacion,style: textStyle,),
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
                Text('Detalles de la factura'.toUpperCase(), style: textGreyBold,),
                Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Tarifa de viaje', style: textStyle,),
                      Text('S/ ${double.parse(detail.precio).toStringAsFixed(2)}', style: textBoldBlack,),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Comisión', style: textStyle,),
                      Text(detail.comision != null ? '- S/ ${double.parse(detail.comision).toStringAsFixed(2)}' : '- S/ 0.00', style: textBoldBlack,),
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
                      Text('Facturación total', style: textStyleHeading18Black,),
                      Text(detail.comision != null ? 'S/ ${(double.parse(detail.precio) - double.parse(detail.comision)).toStringAsFixed(2)}' : 'S/ ${(double.parse(detail.precio).toStringAsFixed(2))}', style: textStyleHeading18Black,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

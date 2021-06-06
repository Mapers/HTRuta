import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/historical_detail_response.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/save_qualification_body.dart';
import 'package:HTRuta/app/components/dialogs.dart';

class HistoryDetail extends StatefulWidget {
  final String id;

  HistoryDetail({this.id});

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String yourReview = '';
  double ratingScore = 2.5;
  final pickupApi = PickupApi();
  HistoryDetailItem detailLoaded;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return detailLoaded == null ? FutureBuilder(
      future: pickupApi.getHistoryDriverDetail(widget.id),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasError) return Container();
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return Scaffold(body: Center(child: CircularProgressIndicator()));
          case ConnectionState.none: return Scaffold(body: Center(child: CircularProgressIndicator()));
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
    ): createContent(screenSize, detailLoaded);
  }
  Widget createContent(Size screenSize, HistoryDetailItem detail){
    return Scaffold(
      bottomNavigationBar: detail.calificacionEstrellas == null ? Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          minWidth: screenSize.width,
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 0.0,
            color: primaryColor,
            child: Text('Enviar',style: headingWhite,
            ),
            onPressed: () async {
              SaveQualificationBody body = SaveQualificationBody(
                viajeId: int.parse(detailLoaded.iIdViaje),
                stars: ratingScore,
                comment: yourReview
              );
              bool success = await pickupApi.sendUserQualification(body);
              if(!success){
                Dialogs.alert(context,title: 'Lo sentimos', message: 'No se pudo guardar su calificación');
                return;
              }else{
                Dialogs.success(
                  context,
                  title: 'Correcto', 
                  message: 'Tu calificación ha sido guardada',
                  onConfirm: (){
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  }
                );
              }
            },
          ),
        ),
      ) : Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          minWidth: screenSize.width,
          height: 50.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 0.0,
            color: Colors.white,
            child: Text('Enviar',style: headingWhite,
            ),
            onPressed: () async {
            },
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Historial',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )
                ),
                background: Container(
                  color: whiteColor,
                ),
              ),
            ),
          ];
        },
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: InkWellCustom(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(AppRoute.driverDetailScreen);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: whiteColor,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(70.0),
                              child:  SizedBox(
                                height: 70,
                                width: 70,
                                child: Hero(
                                  tag: 'avatar_profile',
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: CachedNetworkImageProvider(
                                        'https://source.unsplash.com/300x300/?portrait',
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                width: screenSize.width - 100,
                                padding: EdgeInsets.only(left: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text('Steve Armar',style: textBoldBlack,),
                                        ),
                                        Text('08 Ene 2019 15:34',style: textStyle,),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    rideHistory(detail),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      color: whiteColor,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Detalle de factura (Pago en efectivo)',
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Tarifa de viaje', style: textStyle,),
                                Text('S/.${double.parse(detail.precio).toStringAsFixed(2)}', style: textStyle,),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total Facturado',
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: 16
                                  ),
                                ),
                                Text('S/.${double.parse(detail.precio).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: 16
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    detail.calificacionEstrellas == null ? Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('Calificar viaje',
                        style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                    ) : Container(),
                    detail.calificacionEstrellas == null ? Form(
                        key: formKey,
                        child: Container(
                          padding: EdgeInsets.only(left: 20,top: 10,right: 20),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RatingBar(
                                initialRating: 2.5,
                                allowHalfRating: true,
                                itemSize: 35.0,
                                glowColor: whiteColor,
                                ratingWidget: RatingWidget(
                                  empty: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.amber,
                                  ),
                                  full: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  half: Icon(
                                    Icons.star_half_outlined,
                                    color: Colors.amber,
                                  ) 
                                ),
                                onRatingUpdate: (rating) {
                                  ratingScore = rating;
                                },
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: 100.0,
                                  child: TextField(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Escribe tu reseña',
                                      hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontFamily: 'Akrobat-Bold',
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:BorderRadius.circular(5.0)),
                                    ),
                                    maxLines: 2,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (String value) { 
                                      yourReview = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ) : Container(),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget rideHistory(HistoryDetailItem detail){
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(15.0),
      color: whiteColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: greyColor, width: 1.0),
          color: whiteColor,
        ),
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(detail.fechaRegistro.toString().substring(11, 16),
                        style: TextStyle(
                          color: Color(0xFF97ADB6),
                          fontSize: 13.0
                        ),
                      ),
                      Text(detail.fechaRegistro.add(Duration(minutes: 10)).toString().substring(11, 16),
                        style: TextStyle(
                          color: Color(0xFF97ADB6),
                          fontSize: 13.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.my_location, color: blackColor,),
                    Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      height: 25,
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    Icon(Icons.location_on, color: blackColor,)
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(detail.origen,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(detail.destino,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

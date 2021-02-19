import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../app_router.dart';

class HistoryDetail extends StatefulWidget {
  final String id;

  HistoryDetail({this.id});

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String yourReview;
  double ratingScore;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          minWidth: screenSize.width,
          height: 50.0,
          child: RaisedButton(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
            elevation: 0.0,
            color: primaryColor,
            child: new Text('Enviar',style: headingWhite,
            ),
            onPressed: (){
//              Navigator.of(context).pushReplacementNamed('/history');
//              //and
//              Navigator.popAndPushNamed(context, '/history');
                Navigator.of(context).pushReplacementNamed(AppRoute.historyScreen);
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
                title: Text("Historial",
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
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                                  tag: "avatar_profile",
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: CachedNetworkImageProvider(
                                        "https://source.unsplash.com/300x300/?portrait",
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
                                          child: Text("Steve Armar",style: textBoldBlack,),
                                        ),
                                        Text("08 Ene 2019 15:34",style: textStyle,),
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
                    rideHistory(),
                    new Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      color: whiteColor,
                      child: Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Text("Detalle de factura (Pago en efectivo)",
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
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text("Tarifa de viaje", style: textStyle,),
                                new Text("S/.10.99", style: textStyle,),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text("Impuestos", style: textStyle,),
                                new Text("S/.1.99", style: textStyle,),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text("Descuento", style: textStyle,),
                                new Text("- S/.5.99", style: textStyle,),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text("Total Facturado",
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: 16
                                  ),
                                ),
                                new Text("S/.7.49",
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
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text("Revisar",
                        style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Form(
                        key: formKey,
                        child: Container(
                          padding: EdgeInsets.only(left: 20,top: 10,right: 20),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RatingBar(
                                initialRating: 4,
                                allowHalfRating: true,
                                itemSize: 25.0,
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
                                // itemBuilder: (context, _) => Icon(
                                //   Icons.star,
                                //   color: Colors.amber,
                                // ),
                                onRatingUpdate: (rating) {
                                  ratingScore = rating;
                                  print(rating);
                                },
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: new SizedBox(
                                  height: 100.0,
                                  child: new TextField(
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Escribe tu reseña",
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
                                    onChanged: (String value) { setState(() => yourReview = value );},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rideHistory(){
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
                      Text("10:24",
                        style: TextStyle(
                            color: Color(0xFF97ADB6),
                            fontSize: 13.0
                        ),
                      ),

                      Text("10:50",
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
                    Text('Av. Los incas 567, Trujillo , Perú',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text('Av. Pumacahua 678, El Porvenir, Perú',
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

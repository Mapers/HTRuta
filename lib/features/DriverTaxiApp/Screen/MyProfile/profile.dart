import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyProfile/myProfile.dart';
import '../../../../app/styles/style.dart';
import 'chart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDriver extends StatefulWidget {
  @override
  _ProfileDriverState createState() => _ProfileDriverState();
}

class _ProfileDriverState extends State<ProfileDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return MyProfile();
                  },
              ));
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Column(
            children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    Material(
                      elevation: 10.0,
                      color: Colors.white,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider(
                              'https://source.unsplash.com/1600x900/?portrait',
                            )
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 25.0,
                      height: 15.0,
                      width: 15.0,
                      child: Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenColor,
                            border: Border.all(
                                color: Colors.white, width: 2.0)),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Naomi Cespedes',
                      style: TextStyle( color: blackColor,fontSize: 35.0),
                    ),
                    Text(
                      'Cliente desde 2016',
                      style: TextStyle( color: blackColor, fontSize: 13.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: whiteColor,
                child: LineChartWallet(),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border(
                          bottom: BorderSide(width: 1.0,color: backgroundColor)
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Usuario',style: textStyle,),
                          Text('Oscar Hernandez',style: textGrey,)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(width: 1.0,color: backgroundColor)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Celular',style: textStyle,),
                          Text('918678567',style: textGrey,)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(width: 1.0,color: backgroundColor)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Email',style: textStyle,),
                          Text('oscar.hernandez@gmail.com',style: textGrey,)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              bottom: BorderSide(width: 1.0,color: backgroundColor)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Fecha de nacimiento',style: textStyle,),
                          Text('27/05/1994',style: textGrey,)
                        ],
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

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyProfile/myProfile.dart';
import 'chart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDriver extends StatefulWidget {
  @override
  _ProfileDriverState createState() => _ProfileDriverState();
}

class _ProfileDriverState extends State<ProfileDriver> {
  final Session _session = Session();
  DriverSession driverDataLoaded;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () async {
              bool edited = await Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfile(driverDataLoaded)));
              if(edited!= null && edited){
                driverDataLoaded = null;
                setState(() {});
              }
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: FutureBuilder<DriverSession>(
            future: _session.getDriverData(),
            builder: (context, snapshot) {
              if(snapshot.hasError) return Container();
              switch(snapshot.connectionState){
                case ConnectionState.waiting: return Container();
                case ConnectionState.none: return Container();
                case ConnectionState.active: {
                  driverDataLoaded = snapshot.data;
                  return createContent(driverDataLoaded);
                }
                case ConnectionState.done: {
                  driverDataLoaded = snapshot.data;
                  return createContent(driverDataLoaded);
                }
              }
              return Container();
            }
          ),
        ),
      ),
    );
  }
  Widget createContent(DriverSession driverData){
    return Column(
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
                      backgroundImage: driverData.imageUrl != null ?  CachedNetworkImageProvider(
                        driverData.imageUrl,
                      ) : CachedNetworkImageProvider(
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
                      color: Colors.white, width: 2.0
                    )
                  ),
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
              Container(
                width: MediaQuery.of(context).size.width  * 0.9,
                child: Text(
                  driverData.name ?? '',
                  style: TextStyle( color: blackColor,fontSize: 35.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Cliente desde ${driverData.fechaRegistro.substring(0, 4)}',
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
                    Text('Usuario', style: textStyle),
                    Text(driverData.name ?? '', style: textGrey,)
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
                    Text(driverData.phone ?? '', style: textGrey,)
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
                    Text(driverData.email ?? '',style: textGrey,)
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
                    Text(driverData?.fechaNacimiento, style: textGrey,)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

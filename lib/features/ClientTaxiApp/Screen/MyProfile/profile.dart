import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final Session _session = Session();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: appTheme?.backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return EditProfile();
                  },
              ));
            },
          )
        ],
      ),

      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: FutureBuilder(
          future: _session.get(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return SingleChildScrollView(
                  child: Container(
                    color: appTheme?.backgroundColor,
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
// 'dni' : dni,
//       'nombres' : nombres,
//       'apellidoPaterno': apellidoPaterno,
//       'apellidoMaterno' : apellidoMaterno,
//       'celular' : celular,
//       'correo' : correo,
//       'password' : password,
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${snapshot.data['nombres']} ${snapshot.data['apellidoPaterno']} ${snapshot.data['apellidoMaterno']}',
                                style: TextStyle( color: blackColor,fontSize: 35.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Cliente desde 2020',
                                style: TextStyle( color: blackColor, fontSize: 13.0),
                              ),
                            ],
                          ),
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
                                        bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Usuario',style: textStyle,),
                                    Text('${snapshot.data['nombres']}',style: textGrey,)
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border(
                                        bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Numero de celular',style: textStyle,),
                                    Text('${snapshot.data['celular']}',style: textGrey,)
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border(
                                        bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Email',style: textStyle,),
                                    Text('${snapshot.data['correo']}',style: textGrey,)
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: whiteColor,
                                    border: Border(
                                        bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('DNI',style: textStyle,),
                                    Text('${snapshot.data['dni']}',style: textGrey,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }else{
                return Center(child: Text('Ocurrió un error, intentelo otra vez'),); 
              }
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        ),
      )
    );
  }
}

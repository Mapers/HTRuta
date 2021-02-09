import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/utils/session.dart';
import '../../../app_router.dart';
import '../MyProfile/profile.dart';
import '../../theme/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../MyProfile/myProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuItems {
  String name;
  IconData icon;
  MenuItems({this.icon, this.name});
}

class MenuDriverScreens extends StatelessWidget {
  final String activeScreenName;
  final Session _session = Session();

  MenuDriverScreens({this.activeScreenName});

  navigatorRemoveUntil(BuildContext context, String router){
    Navigator.of(context).pushNamedAndRemoveUntil('/$router', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          FutureBuilder<dynamic>(
            future: _session.get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  return Container(
                    padding: EdgeInsets.only(left: 20.0,top: 30.0,right: 20.0,bottom: 0.0),
                    color: primaryColor,
                    height: 180.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).push(new MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ProfileDriver();
                                  },
                                fullscreenDialog: true));
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(50.0),
                                child: new ClipRRect(
                                  borderRadius: new BorderRadius.circular(100.0),
                                  child: new Container(
                                    height: 50.0,
                                    width: 50.0,
                                    color: primaryColor,
                                    child: CachedNetworkImage(
                                      imageUrl: "https://source.unsplash.com/1600x900/?portrait",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).push(new MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return MyProfile();
                                  },
                                  fullscreenDialog: true));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Naomi Cespedes",style: textBoldWhite,),
                                    Container(
                                      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text("Miembro Gold",style: TextStyle(
                                        fontSize: 11,
                                        color: primaryColor,
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.access_time,color: greyColor,),
                                    Text("10.2",style: heading18,),
                                    Text("Horas online",style: TextStyle(
                                      fontSize: 11,
                                      color: greyColor,
                                    ),),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.poll,color: greyColor,),
                                    Text("30 KM",style: heading18,),
                                    Text("Distancia total",style: TextStyle(
                                      fontSize: 11,
                                      color: greyColor,
                                    ),),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.content_paste,color: greyColor,),
                                    Text("22",style: heading18,),
                                    Text("Trabajo total",style: TextStyle(
                                      fontSize: 11,
                                      color: greyColor,
                                    ),),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  );
            }else{
              return Center(child: Text('Sin informacion del perfil'),);
            }
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ),

//          UserAccountsDrawerHeader(
//            margin: EdgeInsets.all(0.0),
//            accountName: new Text("John",style: headingWhite,),
//            accountEmail: new Text("100 point - Gold member"),
//            currentAccountPicture: new CircleAvatar(
//                backgroundColor: Colors.white,
//                child: new Image(
//                    width: 100.0,
//                    image: new AssetImage('assets/image/taxi-driver.png',)
//                )
//            ),
//            onDetailsPressed: (){
//              Navigator.pop(context);
//              Navigator.of(context).push(new MaterialPageRoute<Null>(
//                  builder: (BuildContext context) {
//                    return MyProfile();
//                  },
//                  fullscreenDialog: true));
//            },
//          ),
          new MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: new Expanded(
              child: new ListView(
                //padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'home_driver');
                            },
                            child: new Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("HOME") == 0 ? greyColor : whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.home,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Inicio',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'request_driver');
                            },
                            child: new Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("REQUEST") == 0 ? greyColor : whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.firstOrder,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Solicitudes',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'my_wallet_driver');
                            },
                            child: new Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("MY WALLET") == 0 ? greyColor : whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.wallet,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Mi billetera',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'history_driver');
                            },
                            child: new Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("HISTORY") == 0 ? greyColor : whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.history,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Historial',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'notification_driver');
                            },
                            child: new Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("NOTIFICATIONS") == 0 ? greyColor : whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.bell,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Notificaciones',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'setting_driver');
                            },
                            child: new Container(
                              height: 60.0,
                              color: this.activeScreenName.compareTo("SETTINGS") == 0 ? greyColor : whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.cogs,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Configuraciones',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new GestureDetector(
                            onTap: () async{
                            
                              await _session.clear();
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'login');
                            },
                            child: new Container(
                              height: 60.0,
                              color: whiteColor,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 1,
                                    child: Icon(FontAwesomeIcons.signOutAlt,color: blackColor,),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new Text('Salir',style: headingBlack,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // The drawer's "details" view.
                    ],
                  ),
                ],
              ),
            ),
          ),
           Container(
             height: 2.0,
             color: Colors.blueGrey,
           ),
           SizedBox(height: 20.0,),
           FlatButton(
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen, (Route<dynamic> route) => false);
                            }, 
                            child: Text('Modo Pasajero',style: TextStyle(color: Colors.white),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                          ),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}

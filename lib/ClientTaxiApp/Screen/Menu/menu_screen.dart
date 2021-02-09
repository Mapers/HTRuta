import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/Screen/MyProfile/profile.dart';
import 'package:HTRuta/ClientTaxiApp/theme/style.dart';
import 'package:HTRuta/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItems {
  String name;
  IconData icon;
  MenuItems({this.icon, this.name});
}

class MenuScreens extends StatelessWidget {
  final String activeScreenName;

  MenuScreens({this.activeScreenName});

  @override
  Widget build(BuildContext context) {
    final Session _session = Session();
    return Drawer(
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: _session.get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  final data = snapshot.data;
                  return UserAccountsDrawerHeader(
                    margin: EdgeInsets.all(0.0),
                    accountName: Text(data['nombres'].toString(),style: headingWhite,),
                    accountEmail: Text("100 puntos - miembro Gold"),
                    currentAccountPicture: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                        "https://source.unsplash.com/300x300/?portrait",
                      )
                    ),
                    onDetailsPressed: (){
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return ProfileScreen();
                          },
                          fullscreenDialog: true
                        )
                      );
                    },
                  );
                }else{
                  return Center(child: Text('Sin informacion del perfil'),);
                }
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowGlow();
                    return false;
                  },
                child: ListView(
                  //padding: const EdgeInsets.only(top: 8.0),
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        // The initial contents of the drawer.
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen, (Route<dynamic> route) => false);},
                              child: Container(
                                height: 60.0,
                                color: this.activeScreenName.compareTo("HOME") == 0 ? greyColor2 : whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.home,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Inicio',style: headingBlack,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen2, (Route<dynamic> route) => false);},
                              child: Container(
                                height: 60.0,
                                color: this.activeScreenName.compareTo("HOME2") == 0 ? greyColor2 : whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.home,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Carros',style: headingBlack,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.paymentMethodScreen);
                              },
                              child: Container(
                                height: 60.0,
                                color: this.activeScreenName.compareTo("PAYMENT") == 0 ? greyColor2 : whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.wallet,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Pagos',style: headingBlack,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.historyScreen);
                              },
                              child: Container(
                                height: 60.0,
                                color: this.activeScreenName.compareTo("HISTORY") == 0 ? greyColor2 : whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.history,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Mis viajes',style: headingBlack,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.cargaScreen);
                              },
                              child: Container(
                                height: 60.0,
                                color: this.activeScreenName.compareTo("CARGA") == 0 ? greyColor2 : whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.truck,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Carga',style: headingBlack,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.termsConditionsScreen);
                              },
                              child: Container(
                                height: 60.0,
                                color: this.activeScreenName.compareTo("TERMS") == 0 ? greyColor2 : whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.cogs,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Terminos y Condiciones',style: headingBlack,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                await _session.clear();
                                Navigator.pop(context);
                                Navigator.of(context).pushReplacementNamed(AppRoute.loginScreen);
                              },
                              child: Container(
                                height: 60.0,
                                color: whiteColor,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(FontAwesomeIcons.signOutAlt,color: blackColor,),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text('Salir',style: headingBlack,),
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
              )
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
                              Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeDriverScreen, (Route<dynamic> route) => false);
                            }, 
                            child: Text('Modo Conductor',style: TextStyle(color: Colors.white),),
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

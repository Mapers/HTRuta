import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import '../../../../app_router.dart';
import '../MyProfile/profile.dart';
import '../../../../app/styles/style.dart';
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

  void navigatorRemoveUntil(BuildContext context, String router){
    Navigator.of(context).pushNamedAndRemoveUntil('/$router', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: <Widget>[
          FutureBuilder<UserSession>(
            future: _session.get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  final data = snapshot.data;
                  return Container(
                    padding: EdgeInsets.only(left: 20.0,top: 30.0,right: 20.0,bottom: 0.0),
                    color: primaryColor,
                    height: 180.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).push( MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ProfileDriver();
                                  },
                                fullscreenDialog: true));
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(50.0),
                                child:ClipRRect(
                                  borderRadius:BorderRadius.circular(100.0),
                                  child:Container(
                                    height: 50.0,
                                    width: 50.0,
                                    color: primaryColor,
                                    child: CachedNetworkImage(
                                      imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).push( MaterialPageRoute<Null>(
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
                                    Text(data.names.toString(),style: textBoldWhite,),
                                    Container(
                                      padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text('Miembro Gold',style: TextStyle(
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
                        /* Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.access_time,color: greyColor,),
                                    Text('10.2',style: heading18,),
                                    Text('Horas online',style: TextStyle(
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
                                    Text('30 KM',style: heading18,),
                                    Text('Distancia total',style: TextStyle(
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
                                    Text('22',style: heading18,),
                                    Text('Trabajo total',style: TextStyle(
                                      fontSize: 11,
                                      color: greyColor,
                                    ),),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ), */
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
//            accountName:Text('John',style: headingWhite,),
//            accountEmail:Text('100 point - Gold member'),
//            currentAccountPicture:CircleAvatar(
//                backgroundColor: Colors.white,
//                child:Image(
//                    width: 100.0,
//                    image:AssetImage('assets/image/taxi-driver.png',)
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
        MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child:Expanded(
              child:ListView(
                //padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'home_driver');
                            },
                            isSelected: activeScreenName.compareTo('HOME') == 0,
                            icon: FontAwesomeIcons.home,
                            text: 'Inicio'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'request_driver');
                            },
                            isSelected: activeScreenName.compareTo('REQUEST') == 0,
                            icon: FontAwesomeIcons.firstOrder,
                            text: 'Solicitudes'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'my_wallet_driver');
                            },
                            isSelected: activeScreenName.compareTo('MY WALLET') == 0,
                            icon: FontAwesomeIcons.wallet,
                            text: 'Mi billetera'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(Routes.toRouterDrivePage(), (_) => false);
                            },
                            isSelected: activeScreenName.compareTo('Rutas') == 0,
                            icon: FontAwesomeIcons.mapMarkedAlt,
                            text: 'Mis Rutas'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'history_driver');
                            },
                            isSelected: activeScreenName.compareTo('HISTORY') == 0,
                            icon: FontAwesomeIcons.history,
                            text: 'Historial'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'notification_driver');
                            },
                            isSelected: activeScreenName.compareTo('NOTIFICATIONS') == 0,
                            icon: FontAwesomeIcons.bell,
                            text: 'Notificaciones'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'setting_driver');
                            },
                            isSelected: activeScreenName.compareTo('SETTINGS') == 0,
                            icon: FontAwesomeIcons.cogs,
                            text: 'Configuraciones'
                          ),
                          getItemMenu(
                            onTap: () async{
                              await _session.clear();
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'login');
                            },
                            isSelected: false,
                            icon: FontAwesomeIcons.signOutAlt,
                            text: 'Salir'
                          )
                        ],
                      ),
                      // The drawer's 'details' view.
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
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeClientScreen, (Route<dynamic> route) => false);
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

  Widget getItemMenu({@required IconData icon, @required String text, @required Function onTap, @required bool isSelected}){
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: blackColor,),
      title: Text(text, style: TextStyle(color: blackColor, fontSize: 16)),
      selected: isSelected,
      selectedTileColor: primaryColor.withOpacity(.5),
    );
  }
}

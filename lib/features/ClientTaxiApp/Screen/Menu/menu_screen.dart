import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/MyProfile/profile.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
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
      elevation: 0,
      child: Column(
        children: <Widget>[
          FutureBuilder<UserSession>(
            future: _session.get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  final data = snapshot.data;
                  return UserAccountsDrawerHeader(
                    margin: EdgeInsets.all(0.0),
                    accountName: Text(data.names,style: headingWhite,),
                    accountEmail: Text('100 puntos - miembro Gold'),
                    currentAccountPicture: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                        'https://source.unsplash.com/300x300/?portrait',
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
                            getItemMenu(
                              icon: FontAwesomeIcons.home,
                              text: 'Inicio',
                              isSelected: activeScreenName.compareTo('HOME') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen, (Route<dynamic> route) => false);
                              },
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.car,
                              text: 'Carros',
                              isSelected: activeScreenName.compareTo('HOME2') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen2, (Route<dynamic> route) => false);
                              },
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.wallet,
                              text: 'Pagos',
                              isSelected: activeScreenName.compareTo('PAYMENT') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen2, (Route<dynamic> route) => false);
                              },
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.history,
                              text: 'Mis viajes',
                              isSelected: activeScreenName.compareTo('HISTORY') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.historyScreen);
                              },
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.truck,
                              text: 'Carga',
                              isSelected: activeScreenName.compareTo('CARGA') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.cargaScreen);
                              },
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.cogs,
                              text: 'Términos y Condiciones',
                              isSelected: activeScreenName.compareTo('TERMS') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.termsConditionsScreen);
                              },
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.signOutAlt,
                              text: 'Salir',
                              isSelected: false,
                              onTap: () async {
                                await _session.clear();
                                Navigator.pop(context);
                                Navigator.of(context).pushReplacementNamed(AppRoute.loginScreen);
                              },
                            ),
                          ],
                        ),
                        // The drawer's 'details' view.
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
              Navigator.pushAndRemoveUntil(context, Routes.toHomeDriverPage(), (_) => false);
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

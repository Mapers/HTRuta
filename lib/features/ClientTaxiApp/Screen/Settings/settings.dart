import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/listMenu.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/MyProfile/edit_profile.dart';
import 'package:share/share.dart';
import 'package:HTRuta/app_router.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final String screenName = 'SETTINGS';
  final Session _session = Session();
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text('Configuraciones',style: TextStyle(color: blackColor)),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer:MenuScreens(activeScreenName: screenName),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
              color: Colors.grey[300],
              child: Column(
                children: <Widget>[
                  FutureBuilder<UserSession>(
                    future: _session.get(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData){
                          final data = snapshot.data;
                          return GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return EditProfile(data);
                                },
                              ));
                            },
                            child: Container(
                              color: whiteColor,
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(top: 10.0,bottom: 20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(50.0),
                                    child:ClipRRect(
                                      borderRadius:BorderRadius.circular(50.0),
                                      child:Container(
                                        height: 80.0,
                                        width: 80.0,
                                        child: CachedNetworkImage(
                                          imageUrl: data.imageUrl.isNotEmpty ? data.imageUrl : 'https://source.unsplash.com/1600x900/?portrait',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ),
                                  ),
                                  Container(
                                    width: screenSize.width * 0.7 ,
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(data.names,style: textBoldBlack,),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  )
                                ],
                              ),
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
                  /* ListsMenu(
                    title: '100 Puntos * Miembro',
                    onPress: (){

                    },
                  ), */
                  ListsMenu(
                    title: 'Reseñas',
                    onPress: (){

                    },
                  ),
                  /* ListsMenu(
                    title: 'Invitar amigos',
                    onPress: (){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return InviteFriends();
                          },
                          fullscreenDialog: true));
                    },
                  ), */
                  ListsMenu(
                    title: 'Notificaciones',
                    onPress: (){
                      Navigator.of(context).pushNamed(AppRoute.notificationScreen);
                    },
                  ),
                  ListsMenu(
                    title: 'Compartir aplicación',
                    onPress: (){
                      Share.share('Te invito a descargar esta aplicación https://google.com');
                    },
                  ),
                  ListsMenu(
                    title: 'Terminos y condiciones',
                    onPress: (){
                      Navigator.of(context).pushNamed(AppRoute.termsConditionsScreen);
                    },
                  ),
                  ListsMenu(
                    title: 'Contactanos',
                    onPress: (){

                    },
                  ),
                ],
              )
            ),
          ),
        ),
      )
    );
  }
}

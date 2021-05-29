import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/listMenu.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/MyProfile/edit_profile.dart';
import 'invite_friends.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String screenName = 'SETTINGS';


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text('Configuraciones',style: TextStyle(color: blackColor),),
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
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return EditProfile();
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
                                      child:Image.asset('assets/image/taxi-driver.png',fit: BoxFit.cover, height: 100.0,width: 100.0,)
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
                                        child: Text('Steve Armas',style: textBoldBlack,),
                                      ),
                                      Container(
                                          child: Text('\$25.0',style: textStyleHeading18Black,)
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
                    ),
                    ListsMenu(
                      title: '100 Puntos * Miembro',
                      onPress: (){

                      },
                    ),
                    ListsMenu(
                      title: 'Reseñas',
                      onPress: (){

                      },
                    ),
                    ListsMenu(
                      title: 'Invitar amigos',
                      onPress: (){
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return InviteFriends();
                            },
                            fullscreenDialog: true));
                      },
                    ),
                    ListsMenu(
                      title: 'Notificaciones',
                      onPress: (){

                      },
                    ),
                    ListsMenu(
                      title: 'Terminos y condiciones',
                      onPress: (){

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

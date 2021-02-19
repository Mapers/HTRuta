import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/listMenu.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyProfile/profile.dart';
import 'inviteFriends.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsDriverScreen extends StatefulWidget {
  @override
  _SettingsDriverScreenState createState() => _SettingsDriverScreenState();
}

class _SettingsDriverScreenState extends State<SettingsDriverScreen> {
  final String screenName = "SETTINGS";


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        title: Text('Configuraciones',style: TextStyle(color: blackColor),),
      ),
      drawer: new MenuDriverScreens(activeScreenName: screenName),
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Container(
            color: backgroundColor,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return ProfileDriver();
                        },
                    ));
                  },
                  child: Container(
                    color: whiteColor,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                    child: Row(
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(50.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CachedNetworkImage(
                              imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                              fit: BoxFit.cover,
                              width: 50.0,
                              height: 50.0,
                            ),
                          ),
                        ),
                        Container(
                          width: screenSize.width-70 ,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text("Steve Armas",style: textBoldBlack,),
                                    ),
                                    Container(
                                        child: Text("Miembro Gold",style: TextStyle(
                                          fontSize: 12,
                                          color: greyColor2
                                        ),)
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.arrow_forward_ios,color: CupertinoColors.lightBackgroundGray,)
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
//                ListsMenu(
//                  title: "100 Point * Member",
//                  onPress: (){
//
//                  },
//                ),
                ListsMenu(
                  title: "Reseñas",
                  icon: Icons.star,
                  backgroundIcon: Colors.cyan,
                  onPress: (){

                  },
                ),
                ListsMenu(
                  title: "Invitar amigos",
                  icon: Icons.people,
                  backgroundIcon: primaryColor,
                  onPress: (){
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return InviteFriends();
                        },
                        fullscreenDialog: true));
                  },
                ),
                ListsMenu(
                  title: "Notificacion",
                  icon: Icons.notifications_active,
                  backgroundIcon: primaryColor,
                  onPress: (){

                  },
                ),
                ListsMenu(
                  title: "Términos y condiciones",
                  icon: Icons.description,
                  backgroundIcon: Colors.deepPurple,
                  onPress: (){

                  },
                ),
                ListsMenu(
                  title: "Contactanos",
                  icon: Icons.help,
                  backgroundIcon: primaryColor,
                  onPress: (){

                  },
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/listMenu.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyProfile/profile.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'inviteFriends.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

class SettingsDriverScreen extends StatefulWidget {
  @override
  _SettingsDriverScreenState createState() => _SettingsDriverScreenState();
}

class _SettingsDriverScreenState extends State<SettingsDriverScreen> {
  final String screenName = 'SETTINGS';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final Session _session = Session();
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuDriverScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: whiteColor,
          centerTitle: true,
          title: Text('Configuraciones',style: TextStyle(color: blackColor)),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              final _state = _sideMenuKey.currentState;
              if (_state.isOpened)
                _state.closeSideMenu(); // close side menu
              else
                _state.openSideMenu();// open side menu
            },
          ),
        ),
        drawer: MenuDriverScreens(activeScreenName: screenName),
        body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
            child: Container(
              color: backgroundColor,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return ProfileDriver();
                        },
                      ));
                    },
                    child: Container(
                      color: whiteColor,
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                      child: FutureBuilder<DriverSession>(
                        future: _session.getDriverData(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasData){
                              final data = snapshot.data;
                              return Row(
                                children: [
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: data.imageUrl != null ?  CachedNetworkImage(
                                        imageUrl: data.imageUrl,
                                        fit: BoxFit.cover,
                                        width: 50.0,
                                        height: 50.0,
                                      ) : Container(),
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
                                                child: Text(data.name.toString(),style: textBoldBlack,),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Miembro Gold',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: greyColor2
                                                  )
                                                )
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
                                  ),
                                ],
                              );
                            }else{
                              return Center(child: Text('Sin informacion del perfil'),);
                            }
                          }else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        }
                      ),
                    ),
                  ),
  //                ListsMenu(
  //                  title: '100 Point * Member',
  //                  onPress: (){
  //
  //                  },
  //                ),
                  ListsMenu(
                    title: 'Reseñas',
                    icon: Icons.star,
                    backgroundIcon: Colors.cyan,
                    onPress: (){

                    },
                  ),
                  ListsMenu(
                    title: 'Invitar amigos',
                    icon: Icons.people,
                    backgroundIcon: primaryColor,
                    onPress: (){
                      Navigator.of(context).push( MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return InviteFriends();
                          },
                          fullscreenDialog: true));
                    },
                  ),
                  ListsMenu(
                    title: 'Notificacion',
                    icon: Icons.notifications_active,
                    backgroundIcon: primaryColor,
                    onPress: (){

                    },
                  ),
                  ListsMenu(
                    title: 'Compartir aplicación',
                    icon: Icons.share,
                    backgroundIcon: primaryColor,
                    onPress: (){
                      Share.share('Te invito a descargar esta aplicación https://google.com');
                    },
                  ),
                  ListsMenu(
                    title: 'Términos y condiciones',
                    icon: Icons.description,
                    backgroundIcon: Colors.deepPurple,
                    onPress: (){
                      
                    },
                  ),
                  ListsMenu(
                    title: 'Contactanos',
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
      )
    );
  }
}

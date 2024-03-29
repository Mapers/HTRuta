import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Repository/driver_firestore_service.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../MyProfile/profile.dart';
import '../../../../app/styles/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuItems {
  String name;
  IconData icon;
  MenuItems({this.icon, this.name});
}

class MenuDriverScreens extends StatefulWidget {
  final String activeScreenName;

  MenuDriverScreens({this.activeScreenName});

  @override
  _MenuDriverScreensState createState() => _MenuDriverScreensState();
}

class _MenuDriverScreensState extends State<MenuDriverScreens> {
  final Session _session = Session();

  final DriverFirestoreService driverFirestoreService = DriverFirestoreService();

  void navigatorRemoveUntil(BuildContext context, String router){
    Navigator.of(context).pushNamedAndRemoveUntil('/$router', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: <Widget>[
          FutureBuilder<DriverSession>(
            future: _session.getDriverData(),
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
                              onTap: () async {
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDriver()));
                                setState(() {});
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(50.0),
                                child: ClipRRect(
                                  borderRadius:BorderRadius.circular(100.0),
                                  child: Container(
                                    height: 70.0,
                                    width: 70.0,
                                    color: primaryColor,
                                    child: data.imageUrl != null  && data.imageUrl.isNotEmpty ? CachedNetworkImage(
                                      imageUrl: data.imageUrl,
                                      fit: BoxFit.cover,
                                    ) : Image.asset(
                                      'assets/image/empty_user_photo.png',
                                    ),
                                  )
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDriver()));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(data.name.toString(), style: textBoldWhite),
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
                              Navigator.pushAndRemoveUntil(context, Routes.toHomeDriverPage(), (_) => false);
                            },
                            isSelected: widget.activeScreenName.compareTo('HOME') == 0,
                            icon: FontAwesomeIcons.home,
                            text: 'Inicio'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'request_driver');
                            },
                            isSelected: widget.activeScreenName.compareTo('REQUEST') == 0,
                            icon: FontAwesomeIcons.firstOrder,
                            text: 'Solicitudes'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'my_wallet_driver');
                            },
                            isSelected: widget.activeScreenName.compareTo('MY WALLET') == 0,
                            icon: FontAwesomeIcons.wallet,
                            text: 'Mi billetera'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'paymentMethods');
                            },
                            isSelected: widget.activeScreenName.compareTo('PAYMENTS') == 0,
                            icon: FontAwesomeIcons.creditCard,
                            text: 'Mis métodos de pago'
                          ),
                          /* getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'driverCupons');
                            },
                            isSelected: widget.activeScreenName.compareTo('CUPONS') == 0,
                            icon: FontAwesomeIcons.tags,
                            text: 'Mis cupones'
                          ), */
                          BlocBuilder<DriverServiceBloc, DriverServiceState>(
                            builder: (ctx, state){
                              DataDriverServiceState data = state;
                              return data.typeService != TypeServiceEnum.taxi ?  getItemMenu(
                                onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(Routes.toRouterDrivePage(), (_) => false);
                                },
                                isSelected: widget.activeScreenName.compareTo('Rutas') == 0,
                                icon: FontAwesomeIcons.mapMarkedAlt,
                                text: 'Mis Rutas'
                              ) : Container();
                            },
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'history_driver');
                            },
                            isSelected: widget.activeScreenName.compareTo('HISTORY') == 0,
                            icon: FontAwesomeIcons.history,
                            text: 'Historial'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'notification_driver');
                            },
                            isSelected: widget.activeScreenName.compareTo('NOTIFICATIONS') == 0,
                            icon: FontAwesomeIcons.bell,
                            text: 'Notificaciones'
                          ),
                          getItemMenu(
                            onTap: () {
                              Navigator.pop(context);
                              navigatorRemoveUntil(context,'setting_driver');
                            },
                            isSelected: widget.activeScreenName.compareTo('SETTINGS') == 0,
                            icon: FontAwesomeIcons.cogs,
                            text: 'Configuraciones'
                          ),
                          getItemMenu(
                            onTap: () async{
                              final _prefs = UserPreferences();
                              await _session.clear();
                              _prefs.setDrivingState = false;
                              _prefs.idChoferReal = '0';
                              driverFirestoreService.updateDriverAvalability(false, _prefs.idChofer);
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
              final _prefs = UserPreferences();
              _prefs.setDrivingState = false;
              driverFirestoreService.updateDriverAvalability(false, _prefs.idChofer);
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
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

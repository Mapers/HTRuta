import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/app_services_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/registro_conductor_api.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/MyProfile/profile.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuItems {
  String name;
  IconData icon;
  MenuItems({this.icon, this.name});
}

class MenuScreens extends StatefulWidget {
  final String activeScreenName;
  MenuScreens({this.activeScreenName});
  @override
  _MenuScreensState createState() => _MenuScreensState();
}

class _MenuScreensState extends State<MenuScreens> {
  final Session _session = Session();

  final _prefs = UserPreferences();

  final registroConductorApi = RegistroConductorApi();

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
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                      setState(() {});
                    },
                    child: UserAccountsDrawerHeader(
                      margin: EdgeInsets.all(0.0),
                      accountName: Text(data.names, style: headingWhite,),
                      // accountEmail: Text('100 puntos - miembro Gold'),
                      accountEmail: Text(data.cellphone),
                      currentAccountPicture: data.imageUrl.isNotEmpty ? CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          data.imageUrl
                        )
                      ) : CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/image/empty_user_photo.png')
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
                              isSelected: widget.activeScreenName.compareTo('HOME') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
                              },
                            ),
                            /* getItemMenu(
                              icon: FontAwesomeIcons.car,
                              text: 'Carros',
                              isSelected: activeScreenName.compareTo('HOME2') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.homeScreen2, (Route<dynamic> route) => false);
                              },
                            ), */
                            /* getItemMenu(
                              icon: FontAwesomeIcons.wallet,
                              text: 'Mis métodos de pago',
                              isSelected: activeScreenName.compareTo('PAYMENT') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.clientPaymentMethods, (Route<dynamic> route) => false);
                              },
                            ), */
                            getItemMenu(
                              icon: FontAwesomeIcons.history,
                              text: 'Mis viajes',
                              isSelected: widget.activeScreenName.compareTo('HISTORY') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.historyScreen);
                              },
                            ),
                            /* getItemMenu(
                              icon: Icons.settings,
                              text: 'Configuracion',
                              isSelected: activeScreenName.compareTo('CONFIG') == 0,
                              onTap: () {
                                
                              },
                            ), */
                            /* getItemMenu(
                              icon: FontAwesomeIcons.truck,
                              text: 'Carga',
                              isSelected: activeScreenName.compareTo('CARGA') == 0,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.cargaScreen);
                              },
                            ), */
                            getItemMenu(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.notificationScreen);
                              },
                              isSelected: widget.activeScreenName.compareTo('NOTIFICATIONS') == 0,
                              icon: FontAwesomeIcons.bell,
                              text: 'Notificaciones'
                            ),
                            getItemMenu(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.settingsScreen);
                              },
                              isSelected: widget.activeScreenName.compareTo('SETTINGS') == 0,
                              icon: FontAwesomeIcons.cogs,
                              text: 'Configuraciones'
                            ),
                            getItemMenu(
                              icon: FontAwesomeIcons.fileAlt,
                              text: 'Términos y Condiciones',
                              isSelected: widget.activeScreenName.compareTo('TERMS') == 0,
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
                                _prefs.idChoferReal = '0';
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(AppRoute.loginScreen);
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
          SizedBox(height: 20.0),
          FlatButton(
            onPressed: () async {
              if(_prefs.idChoferReal != '0' && _prefs.idChoferReal != ''){
                final estado = await registroConductorApi.obtenerEstadoChofer(_prefs.idChoferReal);
                if(estado.iEstado != 'Aprobado'){
                  if(estado.iEstado == 'Rechazado'){
                    Dialogs.confirm(context,title: 'Alerta', message: 'Su solicitud ha sido rechazada \n ¿Desea enviar los documentos que se solicitan?'
                      ,onConfirm: (){
                        Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
                      }
                      ,onCancel: (){
                        Navigator.pop(context);
                      }
                    );
                  }else{
                    Dialogs.confirm(
                      context,
                      title: 'Alerta', 
                      message: 'Su postulación está pendiente de aprobación',
                      onConfirm: () async {
                      },
                    );
                  }
                }else{
                  loadService();
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, Routes.toHomeDriverPage(), (_) => false);
                }
              }else{
                Dialogs.confirm(
                  context,
                  title: 'Alerta', 
                  message: 'Para entrar a la vista de chofer, tiene que postularse primero',
                  onConfirm: () async {
                    Navigator.of(context).pushNamed(AppRoute.registerDriverScreen);
                  },
                  onCancel: () async {

                  }
                );
              }
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
  void loadService(){
    final appServicesProvider = Provider.of<AppServicesProvider>(context, listen: false);
    if(appServicesProvider.taxiAvailable){
      BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: TypeServiceEnum.taxi));
      return;
    }
    if(appServicesProvider.interprovincialAvailable){
      BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: TypeServiceEnum.interprovincial));
      return;
    }
    if(appServicesProvider.heavyLoadAvailable){
      BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: TypeServiceEnum.cargo));
      return;
    }
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

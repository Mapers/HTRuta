import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Notification/itemNotification.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'detail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationDriverScreens extends StatefulWidget {
  @override
  _NotificationDriverScreensState createState() => _NotificationDriverScreensState();
}

class _NotificationDriverScreensState extends State<NotificationDriverScreens> {
  final String screenName = 'NOTIFICATIONS';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  
  List<Map<String, dynamic>> listNotification = <Map<String, dynamic>>[];

  void navigateToDetail(String id){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationDetail(id: id,)));
  }

  Future dialogInfo(){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Confirmar'),
            content: Text('¿Estas seguro de borrar todas las notificaciones ?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){Navigator.pop(context);},
                  child:Text('Cancelar',style: textGrey,)),
              FlatButton(
                  onPressed: (){
                    setState(() {
                      listNotification.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Ok')),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    listNotification = [
      {'id': '0','title' : 'Sistema','subTitle' : 'Se agregaron nuevas funcionalidades', 'icon' : Icons.check_circle},
      {'id': '1','title' : 'Promoción','subTitle' : 'Invita a tus amigos y obtener 3 cupones', 'icon' : MdiIcons.camcorder},
      {'id': '2','title' : 'Promoción','subTitle' : 'Invita a tus amigos y obtener 3 cupones', 'icon' : MdiIcons.camcorder},
      {'id': '3','title' : 'Sistema','subTitle' : 'Reserva #1223 fue cancelado!', 'icon' : MdiIcons.cancel},
      {'id': '3','title' : 'Sistema','subTitle' : 'Gracias, Tu transacción esta hecha!', 'icon' : Icons.check_circle},

    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuDriverScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notificacion',style: TextStyle(color: blackColor),),
          backgroundColor: whiteColor,
          elevation: 2.0,
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
          iconTheme: IconThemeData(color: blackColor),
            actions: <Widget>[
            IconButton(
                icon: Icon(Icons.restore_from_trash,color: blackColor,),
                onPressed: (){
                  dialogInfo();
                }
              )
            ]
        ),
        drawer:MenuDriverScreens(activeScreenName: screenName),
          body: listNotification.isNotEmpty ?
          Scrollbar(
            child: ListView.builder(
                itemCount: listNotification.length,
                itemBuilder: (BuildContext context, int index){
                  return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Eliminar',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: (){
                            setState(() {
                              listNotification.removeAt(index);
                            });
                          },
                        ),
                      ],
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: greyColor,width: 1)
                              )
                          ),
                          child: GestureDetector(
                              onTap: (){
                                print('$index');
                                navigateToDetail(index.toString());
                              },
                              child: ItemNotification(
                                title: listNotification[index]['title'],
                                subTitle: listNotification[index]['subTitle'],
                                icon: listNotification[index]['icon'],
                              )
                          )
                      )
                  );
                }
            ),
          ): Container(
            height: screenSize.height,
            child: Center(
              child: Image.asset('assets/image/empty_state_trash_300.png',width: 100.0,),
            ),
          )
      )
    );
  }
}

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/animation_list_view.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'itemNotification.dart';

class NotificationScreens extends StatefulWidget {
  @override
  _NotificationScreensState createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {
  final String screenName = 'NOTIFICATIONS';
  List<Map<String, dynamic>> listNotification = [];

  /* void navigateToDetail(String id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotificationDetail(
              id: id,
            )));
  } */
  final _prefs = UserPreferences();

  void dialogInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Confirmar Borrado'),
          content: Text('Estas seguro de borrar todas las notificaciones ?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:Text(
                'Cancelar',
                style: textGrey,
              )
            ),
            FlatButton(
              onPressed: () {
                _prefs.clearNotificacionUsuario();
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Ok')
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: TextStyle(color: blackColor),
        ),
        backgroundColor: whiteColor,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: blackColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.restore_from_trash,
              color: blackColor,
            ),
            onPressed: () {
              dialogInfo();
            }
          )
        ]
      ),
      drawer: MenuScreens(activeScreenName: screenName),
      body: _prefs.notificacionesUsuario.isNotEmpty
        ? NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return false;
            },
            child: AnimationLimiter(
              child: ListView.builder(
                  itemCount: _prefs.notificacionesUsuario.reversed.toList().length,
                  padding: EdgeInsets.only(top: 0),
                  itemBuilder: (BuildContext context, int index) {
                    String notificacion = _prefs.notificacionesUsuario.reversed.toList()[index];
                    return AnimationListView(
                      index: index,
                      child: Slidable(
                        actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Borrar',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _prefs.clearNotificacionUsuarioIndex(_prefs.notificacionesUsuario.length - 1 - index);
                              setState(() {});
                            },
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: greyColor2, 
                                width: 1
                              )
                            )
                          ),
                          child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: greyColor,width: 1)
                          )
                        ),
                        child: ItemNotification(
                          title: notificacion.split(',').first,
                          subTitle: notificacion.split(',').last,
                          icon: Icons.check_circle,
                        )
                      )
                    )
                  )
                );
              }
            )
          )
        ): Container(
          child: Center(
            child: Image.asset(
              'assets/image/empty_state_trash_300.png',
              width: 100.0,
            ),
          ),
        ),
    );
  }
}

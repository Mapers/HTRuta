import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/animation_list_view.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'detail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'itemNotification.dart';

class NotificationScreens extends StatefulWidget {
  @override
  _NotificationScreensState createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {
  final String screenName = "NOTIFICATIONS";
  List<Map<String, dynamic>> listNotification = List<Map<String, dynamic>>();

  navigateToDetail(String id) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotificationDetail(
              id: id,
            )));
  }

  dialogInfo() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text("Confirmar Borrado"),
            content: Text("Estas seguro de borrar todas las notificaciones ?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                    'Cancelar',
                    style: textGrey,
                  )),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      listNotification.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listNotification = [
      {
        "id": '0',
        "title": 'Sistema',
        "subTitle": "Sit amet ullamco qui nostrud adipisicing cupidatat dolor duis sit Lorem.",
        "icon": Icons.check_circle
      },
      {
        "id": '1',
        "title": 'Promoción',
        "subTitle": "Ad mollit nulla eiusmod deserunt adipisicing.",
        "icon": MdiIcons.camcorder
      },
      {
        "id": '2',
        "title": 'Promoción',
        "subTitle": "Labore excepteur aliquip exercitation et sint aliqua aliqua dolore.",
        "icon": MdiIcons.camcorder
      },
      {
        "id": '3',
        "title": 'Sistema',
        "subTitle": "Deserunt mollit Lorem aliqua duis.",
        "icon": MdiIcons.cancel
      },
      {
        "id": '3',
        "title": 'Sistema',
        "subTitle": "Exercitation consequat incididunt qui aliquip exercitation.",
        "icon": Icons.check_circle
      },
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          elevation: 0.0,
          iconTheme: IconThemeData(color: blackColor),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.restore_from_trash,
                  color: blackColor,
                ),
                onPressed: () {
                  dialogInfo();
                })
          ]),
      drawer: MenuScreens(activeScreenName: screenName),
      body: listNotification.length != 0
        ? NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return false;
            },
            child: AnimationLimiter(
              child: ListView.builder(
                  itemCount: listNotification.length,
                  padding: EdgeInsets.only(top: 0),
                  itemBuilder: (BuildContext context, int index) {
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
                                setState(() {
                                  listNotification.removeAt(index);
                                });
                              },
                            ),
                          ],
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: greyColor2, width: 1))),
                              child: GestureDetector(
                                  onTap: () {
                                    print('$index');
                                    navigateToDetail(index.toString());
                                  },
                                  child: ItemNotification(
                                    title: listNotification[index]
                                    ['title'],
                                    subTitle: listNotification[index]
                                    ['subTitle'],
                                    icon: listNotification[index]['icon'],
                                  )))),
                    );
                  }),
            )
          )
          : Container(
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

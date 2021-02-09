import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/theme/style.dart';

class NotificationDetail extends StatefulWidget {

  final String id;

  NotificationDetail({this.id});

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
  }

  dialogInfo(){
    AlertDialog(
      title: Text("Información"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      content: Text('Se borro exitosamente'),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Detalle de notificacion',style: TextStyle(color: blackColor),),
          backgroundColor: whiteColor,
          elevation: 2.0,
          iconTheme: IconThemeData(color: blackColor),
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.restore_from_trash,color: blackColor,),
                onPressed: (){showDialog(context: context, child: dialogInfo());}
            )
          ]
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                new Container(
                  height: 220.0,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill, image: AssetImage('assets/image/news.jpg')
                      )
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.all(16.0),
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        "CDC",
                        style: textBoldBlack,
                      ),
                      new Container(
                        padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Icon(
                          Icons.access_time,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      new Expanded(
                          child: new Text(
                            "Hace 1h",
                            style: textBoldBlack,
                          )),
                      new GestureDetector(
                        child: new Container(
                          padding: new EdgeInsets.only(bottom: 5.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                bottom: const BorderSide(
                                    width: 1.0,
                                    color: secondary),
                              )),
                          child: new Text(
                            "AMBIENTE",
                            style: textStyleActive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Text("Esse ullamco sunt excepteur ipsum ea adipisicing est ullamco ut reprehenderit.",style: heading18Black,),
                ),
                new Container(
                  padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: new Text(
                    "Magna deserunt minim ipsum tempor excepteur. Velit deserunt reprehenderit incididunt aliqua id officia. Do anim cupidatat voluptate id culpa pariatur. Minim pariatur commodo deserunt mollit ut laboris cupidatat commodo adipisicing. Excepteur ex fugiat sit mollit dolor magna officia minim veniam exercitation Lorem do tempor laboris.",
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

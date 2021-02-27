import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';

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
      title: Text('Información'),
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
           IconButton(
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
               Container(
                  height: 220.0,
                  decoration:BoxDecoration(
                      image:DecorationImage(
                          fit: BoxFit.fill, image: AssetImage('assets/image/news.jpg')
                      )
                  ),
                ),
               Container(
                  padding:EdgeInsets.all(16.0),
                  child:Row(
                    children: <Widget>[
                     Text(
                        'CDC',
                        style: textBoldBlack,
                      ),
                     Container(
                        padding:EdgeInsets.only(left: 10.0, right: 10.0),
                        child:Icon(
                          Icons.access_time,
                          size: 20.0,
                          color: Colors.black,
                        ),
                      ),
                     Expanded(
                          child:Text(
                            'Hace 1h',
                            style: textBoldBlack,
                          )),
                     GestureDetector(
                        child:Container(
                          padding:EdgeInsets.only(bottom: 5.0),
                          decoration:BoxDecoration(
                              border:Border(
                                bottom: const BorderSide(
                                    width: 1.0,
                                    color: secondary),
                              )),
                          child:Text(
                            'AMBIENTE',
                            style: textStyleActive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Text('Esse ullamco sunt excepteur ipsum ea adipisicing est ullamco ut reprehenderit.',style: textStyleHeading18Black,),
                ),
               Container(
                  padding:EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child:Text(
                    'Magna deserunt minim ipsum tempor excepteur. Velit deserunt reprehenderit incididunt aliqua id officia. Do anim cupidatat voluptate id culpa pariatur. Minim pariatur commodo deserunt mollit ut laboris cupidatat commodo adipisicing. Excepteur ex fugiat sit mollit dolor magna officia minim veniam exercitation Lorem do tempor laboris.',
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

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
    return AlertDialog(
      title: Text("Information"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      content: Text('Delete successful'),
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
          title: Text('Detalle de notificación',style: TextStyle(color: blackColor),),
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
      body: Scrollbar(
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
                            "Ambiente",
                            style: textStyleActive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Text("Aliqua mollit esse officia ad non elit eiusmod quis qui velit.",style: heading18Black,),
                ),
                new Container(
                  padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: new Text(
                    "Elit mollit fugiat elit elit eu Lorem veniam commodo do incididunt. Reprehenderit culpa minim amet amet et voluptate sit eu commodo minim Lorem nostrud commodo ad. Eiusmod esse ad dolor minim id dolor labore irure ea aliqua et. Esse mollit tempor duis dolore laborum minim. Nostrud eu eiusmod dolor pariatur voluptate. Consequat adipisicing ullamco fugiat esse ad elit adipisicing occaecat nostrud dolore aliquip nulla culpa ullamco.",
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

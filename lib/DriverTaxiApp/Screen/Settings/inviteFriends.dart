import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_booking/DriverTaxiApp/theme/style.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  final keyScaffold = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        title: Text('Invitar Amigos',style: TextStyle(color: blackColor),),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back_ios,color: blackColor,),
//          onPressed: () => Navigator.of(context).pushReplacement(
//              new MaterialPageRoute(builder: (context) => LoginScreen2())),
//        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(screenSize.width*0.13, 0.0, screenSize.width*0.13, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(100.0),
                child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(100.0),
                    child: new Container(
                      color: primaryColor,
                        height: 180.0,
                        width: 180.0,
                        child: Icon(Icons.supervisor_account,color: blackColor,size: 100.0,)
                    )
                ),
              ),
            ),
            Container(
              child: Text("Invite a un amigo",style: headingBlack,),
            ),
            Container(
              child: Text("Puedes ganar S/.150 en un dia",style: heading18Black,),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.0,top: 20.0),
              child: Text("Cuando su amigo se registre con su código de referencia, puede recibir hasta S/.150 por día.",
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: double.infinity,
              height: 45.0,
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Center(
                child: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(new ClipboardData(text: '09867656'));
                    
                  },
                  child: Text("09867656",
                    style: heading18Black,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),),
            new ButtonTheme(
              height: 45.0,
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton.icon(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                elevation: 0.0,
                color: primaryColor,
                icon: new Text(''),
                label: new Text('Invitar', style: headingBlack,),
                onPressed: (){
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

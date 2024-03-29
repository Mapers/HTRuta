import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: whiteColor,
        title: Text('Invitar amigos',style: TextStyle(color: blackColor),),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back_ios,color: blackColor,),
//          onPressed: () => Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => LoginScreen2())),
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
                child:ClipRRect(
                    borderRadius:BorderRadius.circular(100.0),
                    child:Container(
                      color: primaryColor,
                        height: 180.0,
                        width: 180.0,
                        child: Icon(Icons.supervisor_account,color: blackColor,size: 100.0,)
                    )
                ),
              ),
            ),
            Container(
              child: Text('Invita a tus amigos',style: headingBlack,),
            ),
            Container(
              child: Text('Gana hasta PEN 150 por día',style: textStyleHeading18Black,),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.0,top: 20.0),
              child: Text('Cuando su amigo se registre con su código de referencia, puede recibir hasta PEN 150 por día',style: textStyle,),
            ),
            Container(
              width: double.infinity,
              height: 45.0,
              decoration: BoxDecoration(
                color: greyColor2,
                borderRadius:BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text('09867656',style: textStyleHeading18Black,),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0),),
           ButtonTheme(
              height: 50.0,
              minWidth: MediaQuery.of(context).size.width,
              child: RaisedButton.icon(
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0)),
                elevation: 0.0,
                color: primaryColor,
                icon:Text(''),
                label:Text('Invitar', style: headingBlack,),
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

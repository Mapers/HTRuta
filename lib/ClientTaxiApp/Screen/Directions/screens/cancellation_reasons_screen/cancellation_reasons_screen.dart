import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/theme/style.dart';
import 'package:HTRuta/app_router.dart';

import 'package:grouped_buttons/grouped_buttons.dart';

class CancellationReasonsScreen extends StatefulWidget {
  @override
  _CancellationReasonsScreenState createState() => _CancellationReasonsScreenState();
}

class _CancellationReasonsScreenState extends State<CancellationReasonsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          height: 50.0,
          minWidth: MediaQuery.of(context).size.width-50,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 0.0,
            color: primaryColor,
            icon: Text(''),
            label: Text('Enviar', style: headingWhite,
            ),
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
            },
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Text("Por favor,seleccione la razon por la cual cancela:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                maxLines: 2,
              )
            ),
            SizedBox(height: screenSize.height*0.08,),
            RadioButtonGroup(
              activeColor: primaryColor,
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
                labels: <String>[
                  "No deseo compartir",
                  "No puedo contactar con el conductor",
                  "El precio no es razonable",
                  "El sitio de recogo es incorrecto",
                ],
                onSelected: (String selected) => print(selected)
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/app/colors.dart';

class FormPage extends StatelessWidget {
  String name;
  String email;
  FormPage({this.name = '', this.email = ''});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _issue = '';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text('Contacto',style: TextStyle(color: blackColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            margin: EdgeInsets.all(screenSize.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nombre:'),
                Container(height: 5),
                TextFormField(
                  initialValue: name,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Nombre:',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                  )
                ),
                Container(height: 10),
                Text('Email:'),
                Container(height: 5),
                TextFormField(
                  initialValue: email,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Email:',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                  )
                ),
                Container(height: 10),
                Text('Asunto:'),
                Container(height: 5),
                TextFormField(
                  onChanged: (String newValue){
                    _issue = newValue;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Asunto',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                  )
                ),
                Container(height: 10),
                Text('Mensaje:'),
                Container(height: 5),
                TextFormField(
                  maxLines: 6,
                    onChanged: (String newValue){
                      _issue = newValue;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      hintText: 'Mensaje',
                      hintStyle: TextStyle(color: Colors.grey
                    ),
                  )
                ),
                Container(
                  height: screenSize.height * 0.05,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                  width: screenSize.width * 0.8,
                  child: MaterialButton(
                    color: primaryColor,
                    child: Text('Enviar', style: TextStyle(color: Colors.white, fontSize: 18)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onPressed: (){
                      print(_issue);
                      print(_message);
                    },
                  ),
                )
              ]
            )
          )
        )
      )
    );
  }
}
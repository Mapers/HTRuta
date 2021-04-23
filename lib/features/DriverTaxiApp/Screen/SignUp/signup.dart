import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/validations.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  Validations validations =  Validations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/image/icon/Layer_2.png'),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18.0, 100.0, 18.0, 0.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            child:  Column(
                              children: <Widget>[
                                Container(
                                  //padding: EdgeInsets.only(top: 100.0),
                                    child:  Material(
                                      borderRadius: BorderRadius.circular(7.0),
                                      elevation: 5.0,
                                      child:  Container(
                                        width: MediaQuery.of(context).size.width - 20.0,
                                        height: MediaQuery.of(context).size.height *0.65,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child:  Form(
                                            child:  Container(
                                              padding: EdgeInsets.all(18.0),
                                              child:  Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    height: 100.0,
                                                    width: 300.0,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text('Registro', style: heading35Black,),
//                                                        Text(' with email and phone number', style: heading35BlackNormal,),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          keyboardType: TextInputType.emailAddress,
                                                          validator: validations.validateEmail,
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            prefixIcon: Icon(Icons.email,
                                                                color: blackColor, size: 20.0),
                                                            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                            hintText: 'Email',
                                                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),

                                                          )
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 20.0),
                                                      ),
                                                      TextFormField(
                                                          keyboardType: TextInputType.phone,
                                                          validator: validations.validateMobile,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                              prefixIcon: Icon(Icons.phone,
                                                                  color: blackColor, size: 20.0),
                                                              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                              hintText: 'Celular',
                                                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                                                      child:  Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            child:  Text('¿Olvidaste tu contraseña ?',style: textStyleActive,),
                                                          ),
                                                        ],
                                                      )

                                                  ),
                                                  ButtonTheme(
                                                    height: 50.0,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: RaisedButton.icon(
                                                      shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(5.0)),
                                                      elevation: 0.0,
                                                      color: primaryColor,
                                                      icon:  Text(''),
                                                      label:  Text('Registrate', style: headingWhite,),
                                                      onPressed: () => Navigator.pushReplacement(context, Routes.toHomeDriverPage()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('¿Ya tienes una cuenta? ',style: textGrey,),
                                        InkWell(
                                          onTap: () => Navigator.pushNamed(context, '/login'),
                                          child:  Text('Iniciar sesión',style: textStyleActive,),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )
                        )
                    ),
                  ]
                  )
                ]
            ),
          )

      ),
    );
  }
}

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/validations.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';
import 'phoneVerification.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations =  Validations();

  submit(){
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      //code
      Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => PhoneVerification()));
    }
  }

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
                        padding: EdgeInsets.fromLTRB(18.0, 150.0, 18.0, 0.0),
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
                                        height: MediaQuery.of(context).size.height *0.4,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child:  Form(
                                            key: formKey,
                                            child:  Container(
                                              padding: EdgeInsets.all(18.0),
                                              child:  Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Login', style: heading35Black,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          keyboardType: TextInputType.phone,
                                                          validator: validations.validateMobile,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                              prefixIcon: Icon(Icons.phone,
                                                                  color: blackColor, size: 20.0,),
                                                              suffixIcon: IconButton(
                                                                icon: Icon(CupertinoIcons.clear_thick_circled,color: greyColor2,),
                                                                onPressed: (){
                                                                },
                                                              ),
                                                              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                              hintText: 'Celular',
                                                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  ButtonTheme(
                                                    height: 50.0,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: RaisedButton.icon(
                                                      shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(5.0)),
                                                      elevation: 0.0,
                                                      color: primaryColor,
                                                      icon:  Text(''),
                                                      label:  Text('Siguiente', style: headingWhite,),
                                                      onPressed: (){
                                                        submit();
                                                        },
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
                                        Text('Crear cuenta nueva',style: textGrey,),
                                        InkWell(
                                          onTap: () => Navigator.pushNamed(context, '/signup2'),
                                          child:  Text('Registrarse',style: textStyleActive,),
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

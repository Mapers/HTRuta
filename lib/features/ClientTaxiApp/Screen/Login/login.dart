import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Login/phone_verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/validations.dart';
import 'package:HTRuta/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = Validations();
  String _phoneNumber = '';
  final authApi = AuthApi();
  bool _isFetching = false;
  bool obscure = true;

  void _submit() async{
    try{
      if(_isFetching) return;
      final isValid = formKey.currentState.validate();
      if(isValid){
        // Dialogs.openLoadingDialog(context);
        // final isOk = await authApi.loginUser(_email, _password);
        // Navigator.pop(context);
        // if(isOk){
          final bool sent = await authApi.getVerificationCode(_phoneNumber);
          if(!sent){
            Dialogs.alert(context,title: 'Error', message: 'No se pudo enviar el código');
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerification(numeroTelefono: _phoneNumber)));
        // }
      }
    } on ServerException catch (error){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  color: Color(0xFFFDD148),
                ),
                Positioned(
                  bottom: 450.0,
                  right: 100.0,
                  child: Container(
                    height: 400.0,
                    width: 400.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Color(0xFFFEE16D),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 500.0,
                  left: 150.0,
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150.0),
                      color: Color(0xFFFEE16D).withOpacity(0.5)
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Material(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Form(
                              key: formKey,
                              child: Container(
                                padding: EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Iniciar sesión', style: heading35Black),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (value){
                                            if(value.length != 9){
                                              return 'Número de teléfono inválido';
                                            }
                                            return null;
                                          },
                                          onChanged: (String newValue){
                                            _phoneNumber = newValue;
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            prefixIcon: Icon(Icons.phone,
                                              color: yellowClear, size: 20.0),
                                            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                            hintText: 'Número de teléfono (+51)',
                                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                          )
                                        ),
                                      ],
                                    ),
                                    ButtonTheme(
                                      height: 50.0,
                                      minWidth: MediaQuery.of(context).size.width,
                                      child: RaisedButton.icon(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                        elevation: 0.0,
                                        color: primaryColor,
                                        icon: Text(''),
                                        label: Text('Iniciar Sesión', style: headingWhite.copyWith(fontSize: 16),),
                                        onPressed: (){
                                          _submit();
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('¿No tienes cuenta? ',style: textGrey,),
                            InkWell(
                              onTap: () => Navigator.of(context).pushNamed(AppRoute.signUpScreen),
                              child: Text('Regístrate',style: textStyleActive,),
                            ),
                          ],
                        )
                      ),
                      /* Container(
                          padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('O',style: textGrey,),
                              SizedBox(height: 15,),                
                              FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Color(0xFFFE4231),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                onPressed: (){}, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.google,color: Colors.white,),
                                    Text('Iniciar sesión con Google',style: TextStyle(color: Colors.white),)
                                  ],
                                )
                              ),
                              SizedBox(height: 20,),
                              /* FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Color(0xFF3D599F),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                onPressed: (){}, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.facebook,color: Colors.white,),
                                    Text('Iniciar sesión con Facebook',style: TextStyle(color: Colors.white),)
                                  ],
                                )
                              ), */
                            ],
                          )
                      ), */
                    ],
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

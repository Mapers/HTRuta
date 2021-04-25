import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/validations.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
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
  String _email = '', _password = '';
  final authApi = AuthApi();
  bool _isFetching = false;
  bool obscure = true;

  void _submit() async{
    try{
      if(_isFetching) return;
      final isValid = formKey.currentState.validate();
      if(isValid){
        Dialogs.openLoadingDialog(context);
        final isOk = await authApi.loginUser(_email, _password);
        Navigator.pop(context);
        if(isOk){
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.splashScreen, (route) => false);
        }
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
                  height: 250.0,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(32, 150, 32, 0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Material(
                            borderRadius: BorderRadius.circular(7),
                            elevation: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 20,
                              height: MediaQuery.of(context).size.height * 0.45,
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
                                      Text('Login', style: heading35Black),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextFormField(
                                              keyboardType: TextInputType.emailAddress,
                                              validator: (value){
                                                Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                RegExp regExp = RegExp(pattern);
                                                if(regExp.hasMatch(value)){
                                                  _email = value;
                                                  return null;
                                                }
                                                return 'Correo inválido';
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                prefixIcon: Icon(Icons.account_box,
                                                  color: yellowClear, size: 20.0),
                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                hintText: 'Correo electrónico',
                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                              )
                                          ),
                                          SizedBox(height: 15),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            obscureText: obscure,
                                            validator: (text){
                                              if(text.isNotEmpty && text.length > 5){
                                                _password = text;
                                                return null;
                                              }
                                              return 'Contraseña mayor a 6 caracteres';
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              prefixIcon: Icon(FontAwesomeIcons.key,
                                                  color: yellowClear, size: 20.0),
                                              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                              hintText: 'Contraseña',
                                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                              suffixIcon: IconButton(
                                                icon: obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off), 
                                                onPressed: (){
                                                  setState(() {
                                                    obscure = !obscure;
                                                  });
                                                }
                                              )
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
                        Container(
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

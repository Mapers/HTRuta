import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/ClientTaxiApp/Components/validations.dart';
import 'package:HTRuta/ClientTaxiApp/theme/style.dart';
import 'package:HTRuta/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/ClientTaxiApp/utils/exceptions.dart';
import 'package:HTRuta/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  String _email = '', _password = '';
  final authApi = AuthApi();
  bool _isFetching = false;
  bool obscure = true;

  _submit() async{
    try{
      if(_isFetching) return;
      final isValid = formKey.currentState.validate();
      if(isValid){
        Dialogs.openLoadingDialog(context);
        final isOk = await authApi.loginUser(_email, _password);
        Navigator.pop(context);
        if(isOk){
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    }on ServerException catch (error){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: error.message);
    }
    // if(isValid){
    //   setState(() {
    //     _isFetching = true;
    //   });
    //   final isOk = await authApi.loginFirebase(context,_email, _password);
    //   setState(() {
    //     _isFetching = false;
    //   });
    //   if(isOk != null){
    //     if(isOk['ok']){
    //       final usuario = await _usuarioApi.loginServer(
    //         context,
    //         email: _email,
    //         password: _password,
    //         idToken: isOk['idToken'],
    //         refreshToken: isOk['refreshToken'],
    //         expiresIn: int.parse(isOk['expiresIn'])
    //       );
    //       if(usuario != null){
    //         print(usuario.token);
    //         AppConfig.codigoUsuario = usuario.codUsu;
    //         authProvider.isLogged = true;
    //         Navigator.pushNamedAndRemoveUntil(context, 'route', (_) => false);
    //       }
    //     }else{
    //       authProvider.isLogged = false;
    //       utils.Dialogs.alert(context,title: 'Error',message: isOk['mensaje']);
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                              color: Color(0xFFFEE16D).withOpacity(0.5))),
                    ),
                    new Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 150.0, 32.0, 0.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  //padding: EdgeInsets.only(top: 100.0),
                                    child: new Material(
                                      borderRadius: BorderRadius.circular(7.0),
                                      elevation: 5.0,
                                      child: new Container(
                                        width: MediaQuery.of(context).size.width - 20.0,
                                        height: MediaQuery.of(context).size.height *0.4,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: new Form(
                                            key: formKey,
                                            child: new Container(
                                              padding: EdgeInsets.all(32.0),
                                              child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Login', style: heading35Black,
                                                  ),
                                                  new Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          keyboardType: TextInputType.emailAddress,
                                                          validator: (value){
                                                            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                            RegExp regExp = new RegExp(pattern);
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
                                                                  color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
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
                                                                  color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
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
                                                  new ButtonTheme(
                                                    height: 50.0,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: RaisedButton.icon(
                                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                                                      elevation: 0.0,
                                                      color: primaryColor,
                                                      icon: new Text(''),
                                                      label: new Text('Iniciar Sesión', style: headingWhite,),
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
                                new Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("¿No tienes cuenta? ",style: textGrey,),
                                        new InkWell(
                                          onTap: () => Navigator.of(context).pushNamed(AppRoute.signUpScreen),
                                          child: new Text("Regístrate",style: textStyleActive,),
                                        ),
                                      ],
                                    )
                                ),
                                new Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("O",style: textGrey,),
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
                                        FlatButton(
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

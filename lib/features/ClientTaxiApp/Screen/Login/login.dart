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
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/sign_up_step1.dart';
import 'package:HTRuta/app_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
  String signature = '';

  void _submit() async{
    try{
      if(_isFetching) return;
      Dialogs.openLoadingDialog(context);
      if(int.tryParse(_phoneNumber) == null){
        Navigator.pop(context);
        Dialogs.alert(context,title: 'Atención', message: 'Ingresé un número de teléfono numérico');
        return;  
      }
      final isValid = formKey.currentState.validate();
      if(isValid){
        final String sent = await authApi.getVerificationCode(_phoneNumber);
        if(sent != 'S'){
          Navigator.pop(context);
          if(sent == 'N'){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpStep1(phoneFromSignIn: _phoneNumber)));
            
            return;
          }else{
            Dialogs.alert(context,title: 'Error', message: 'No se pudo enviar el código');
            return;
          }
        }
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerification(numeroTelefono: _phoneNumber)));
      }else{
        Navigator.pop(context);
        Dialogs.alert(context,title: 'Atención', message: 'Escriba un número de teléfono válido');
      }
    } on ServerException catch (error){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: error.message);
    }
  }

  Future<void> getSignature() async {
    signature = await SmsAutoFill().getAppSignature;
    setState(() {});
  }

  @override
  void initState() {
    getSignature();
    super.initState();
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
                                          keyboardType: TextInputType.phone,
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
                                        Container(height: 10),
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
                        height: 100,
                      ),
                      Text(
                        signature, style: TextStyle(color: Colors.blue[50])
                      )
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

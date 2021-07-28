import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/register_user_model.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class RegisterPhoneVerification extends StatefulWidget {
  
  final RegisterUserModel registerUser;
  RegisterPhoneVerification({this.registerUser});

  @override
  _RegisterPhoneVerificationState createState() => _RegisterPhoneVerificationState();
}

class _RegisterPhoneVerificationState extends State<RegisterPhoneVerification> {
  TextEditingController controller = TextEditingController();
  String thisText = '';
  int pinLength = 6;

  bool hasError = false;
  String errorMessage;
  final authApi = AuthApi();
  bool _isFetching = false;

  void _registerUser() async{
    try{
      if(_isFetching) return;
      Dialogs.openLoadingDialog(context);
      final isOk = await authApi.registerUser(
        context,
        dni: widget.registerUser.dni,
        nombre: widget.registerUser.nombre,
        apellidoPaterno: widget.registerUser.apellidoPaterno,
        apellidoMaterno: widget.registerUser.apellidoMaterno,
        celular: widget.registerUser.celular,
        correo: widget.registerUser.correo,
        password: widget.registerUser.password,
        direccion: widget.registerUser.direccion,
        fechaNacimiento: widget.registerUser.fechaNacimiento,
        referencia: widget.registerUser.referencia,
        tipoDispositivo: widget.registerUser.tipoDispositivo,
        imei: widget.registerUser.imei,
        marca: widget.registerUser.marca,
        nombreDispositivo: widget.registerUser.nombreDispositivo,
        token: widget.registerUser.token, 
        sexo: widget.registerUser.sexo,
        code: widget.registerUser.code
      );
      Navigator.pop(context);
      if(isOk){
        Navigator.pushNamedAndRemoveUntil(context, AppRoute.splashScreen, (route) => false);
      }else{
        Navigator.pop(context);
        Dialogs.alert(context,title: 'Error', message: 'No se pudo registrarlo');
      }
    }on ServerException catch (error){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: blackColor,),
          onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoute.loginScreen),
        ),
      ),
      body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0.0, 20, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                    child: Text('Verificación sms',style: heading35Black,),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text('Ingresa tu código aqui'),
                  ),
                  Center(
                    child: PinCodeTextField(
                      pinBoxWidth: MediaQuery.of(context).size.width * 0.12,
                      autofocus: true,
                      controller: controller,
                      hideCharacter: false,
                      highlight: true,
                      highlightColor: secondary,
                      defaultBorderColor: blackColor,
                      hasTextBorderColor: primaryColor,
                      maxLength: pinLength,
                      hasError: hasError,
                      maskCharacter: '*',
                      onTextChanged: (text) {
                        setState(() {
                          hasError = false;
                        });
                      },
                      onDone: (text){},
                      wrapAlignment: WrapAlignment.start,
                      pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                      pinTextStyle: heading35Black,
                      pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                    ),
                  ),
                  SizedBox(height: 20),
                  ButtonTheme(
                    height: 50.0,
                    minWidth: MediaQuery.of(context).size.width-50,
                    child: RaisedButton.icon(
                      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0)),
                      elevation: 0.0,
                      color: primaryColor,
                      icon:Text(''),
                      label:Text('Verificar ahora', style: headingWhite,),
                      onPressed: () async {
                        if(controller.text != widget.registerUser.code){
                          Dialogs.alert(context,title: 'Lo sentimos', message: 'El código ingresado no es correcto');
                          return;
                        }
                        _registerUser();
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () => Navigator.of(context).pushNamed(AppRoute.loginScreen),
                            child:Text('No recibí un código',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ]
              ),
            ),
          )
      ),
    );
  }
}

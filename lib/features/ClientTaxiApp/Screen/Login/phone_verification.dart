import 'dart:async';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PhoneVerification extends StatefulWidget {
  final String numeroTelefono;
  PhoneVerification({this.numeroTelefono});
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController controller = TextEditingController();
  String thisText = '';
  int pinLength = 6;

  bool hasError = false;
  String errorMessage;
  final authApi = AuthApi();
  bool cancel = false;
  int _start = 60;
  Timer timer;

  @override
  void dispose() { 
    controller?.dispose();
    super.dispose();
  }
  @override
  void initState() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t){
        _start -= 1;
        if(_start <= 0){
          _start = 0;
          timer?.cancel();
          cancel = true;
        }
        if(mounted){
          setState(() {});
        }
      }
    );
    super.initState();
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
                      color: (controller.value.text.length != 6) ? primaryColor.withOpacity(0.6) : primaryColor,
                      icon: Text(''),
                      label: Text('Verificar ahora', style: headingWhite),
                      onPressed: () async {
                        if(controller.value.text.length != 6){
                          return;
                        }
                        Dialogs.openLoadingDialog(context);
                        final isOk = await authApi.loginUserSMS(widget.numeroTelefono, controller.value.text);
                        Navigator.pop(context);
                        if(isOk){
                          Navigator.pushNamedAndRemoveUntil(context, AppRoute.splashScreen, (route) => false);
                        }else{
                          Dialogs.alert(context,title: 'Error', message: 'El código ingresado es incorrecto');
                        }
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          cancel ?  
                          InkWell(
                            onTap: () async {
                              final String sent = await authApi.getVerificationCode(widget.numeroTelefono);
                              if(sent != 'S'){
                                if(sent == 'N'){
                                  Dialogs.alert(context,title: 'Lo sentimos', message: 'No se encuentra registrado');
                                  return;
                                }else{
                                  Dialogs.alert(context,title: 'Error', message: 'No se pudo enviar el código');
                                  return;
                                }
                              }
                              const oneSec = Duration(seconds: 1);
                              _start = 60;
                              cancel = false;
                              timer = Timer.periodic(oneSec, (Timer t){
                                _start -= 1;
                                if(_start <= 0){
                                  _start = 0;
                                  timer?.cancel();
                                  cancel = true;
                                }
                                if(mounted){
                                  setState(() {});
                                }
                                }
                              );
                              if(mounted){
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Reenviar código',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline
                                  )
                                )
                              ],
                            ),
                          ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Reenviar código en $_start seg', style: TextStyle(fontSize: 16, color: Colors.grey))
                            ],
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

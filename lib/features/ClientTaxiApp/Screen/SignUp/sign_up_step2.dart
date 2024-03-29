import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/sign_up_step3.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SignUpStep2 extends StatefulWidget {
  final String numeroTelefono;
  final String validationCode;
  SignUpStep2({this.numeroTelefono, this.validationCode});
  @override
  _SignUpStep2State createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> with CodeAutoFill {
  TextEditingController controller = TextEditingController();
  String thisText = '';
  int pinLength = 6;
  String otpCode;

  bool hasError = false;
  String errorMessage;
  final authApi = AuthApi();
  
  Timer timer;
  bool cancelTimer = false;
  int _start = 60;
  
  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
      if(otpCode != null){
        controller.text = code;
      }
    });
  }

  @override
  void initState() {
    listenForCode();
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t){
      _start -= 1;
      if(_start <= 0){
        _start = 0;
        timer?.cancel();
        cancelTimer = true;
      }
      if(mounted){
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() { 
    controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    print(widget.numeroTelefono);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: blackColor,),
          onPressed: () => Navigator.pop(context),
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
                        if(widget.validationCode == controller.value.text){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpStep3(phoneNumber: widget.numeroTelefono, validationCode: widget.validationCode )));
                        }else{
                          Dialogs.alert(context,title: 'Error', message: 'El código ingresado no es correcto');
                        }
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          cancelTimer ?  
                          InkWell(
                            onTap: () async {
                              authApi.getVerificationCodeRegister(widget.numeroTelefono);
                              const oneSec = Duration(seconds: 1);
                              _start = 60;
                              cancelTimer = false;
                              timer = Timer.periodic(oneSec, (Timer t){
                                _start -= 1;
                                if(_start <= 0){
                                  _start = 0;
                                  timer?.cancel();
                                  cancelTimer = true;
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
                          ) :
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

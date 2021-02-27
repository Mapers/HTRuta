import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController controller = TextEditingController();
  String thisText = '';
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

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
                  children: <Widget>[
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
                        onDone: (text){
                          print('DONE $text');
                        },
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
                        onPressed: (){
                          print('hello world');
                          Navigator.of(context).pushReplacementNamed(AppRoute.introScreen);
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

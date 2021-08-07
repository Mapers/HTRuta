import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/sign_up_step2.dart';
import 'package:HTRuta/app/components/dialogs.dart';

class SignUpStep1 extends StatelessWidget {
  String _phoneNumber = '';
  final authApi = AuthApi();

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: mqHeigth(context, 10)
                      ),
                      Text('Ingrese su número de teléfono para iniciar el registro', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                      Container(
                        height: mqHeigth(context, 40)
                      ),
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
                        ],
                      ),
                    ]
                  )
                ),
                Positioned(
                  bottom: 40.0,
                  child: Container(
                    width: mqWidth(context, 60),
                    margin: EdgeInsets.symmetric(horizontal: mqWidth(context, 20)),
                    child: ButtonTheme(
                      height: 50.0,
                      minWidth: mqWidth(context, 60),
                      child: RaisedButton.icon(
                        shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15.0)),
                        elevation: 0.0,
                        color: primaryColor,
                        icon:  Text(''),
                        label:  Text('Siguiente', style: headingWhite,),
                        onPressed: () async {
                          Dialogs.openLoadingDialog(context);
                          final String codeSent = await authApi.getVerificationCodeRegister(_phoneNumber);
                          if(codeSent.isEmpty){
                            Navigator.pop(context);
                            Dialogs.alert(context,title: 'Error', message: 'No se pudo enviar el código');
                            return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpStep2(numeroTelefono: _phoneNumber, validationCode: codeSent)));
                        }
                      ),
                    ),
                  ),
                ),
              ]
            )
            ]
          )
        )
      )
    );        
  }
}
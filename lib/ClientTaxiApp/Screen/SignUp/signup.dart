import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Apis/auth_api.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Apis/tabla_api.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Components/inputDropdown.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Components/validations.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Model/tabla_codigo.dart';
import 'package:flutter_map_booking/ClientTaxiApp/theme/style.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/dialogs.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/exceptions.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:intl/intl.dart';

const double _kPickerSheetHeight = 216.0;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  Validations validations = new Validations();
  bool obscure = true;
  DateTime date = DateTime.now();
  bool _isFetching = false;
  final authApi = AuthApi();
  String _email='', _password='',_nombres='',_apellidoP='',_apellidoM='',_dni='',_direccion='',_referencia='',_celular='';
  int _selectedSexo;
  final tablaApi = TablaApi();

  _submit() async{
    try{
      if(_selectedSexo == 0){
        Dialogs.alert(context,title: 'Error', message:'Debe seleccionar su Sexo');
        return;
      }
      if(_isFetching) return;
      final isValid = formKey.currentState.validate();
      if(isValid){
        Dialogs.openLoadingDialog(context);
        final deviceInfo = DeviceInfoPlugin();
        int dispositivo = 1;
        String marca='';
        String nombreDispositivo = '';
        String imei = '';
        if(Platform.isAndroid){
          dispositivo = 2;
          AndroidDeviceInfo info = await deviceInfo.androidInfo;
          marca = info.model;
          nombreDispositivo = info.device;
          imei = info.androidId;
        }else if (Platform.isIOS){
          dispositivo = 1;
          IosDeviceInfo info = await deviceInfo.iosInfo;
          marca = info.model;
          nombreDispositivo = info.name;
          imei = info.identifierForVendor;
        }
        print('Marca: $marca, NombreD = $nombreDispositivo, IMEI = $imei');
        final _prefs = PreferenciaUsuario();
        await _prefs.initPrefs();
        final token = await _prefs.tokenPush;
        final isOk = await authApi.registerUser(context,dni: _dni,nombre: _nombres,apellidoPaterno: _apellidoP,apellidoMaterno: _apellidoM,celular: _celular,correo: _email,password: _password,direccion: _direccion,fechaNacimiento: date.toString(),referencia: _referencia,tipoDispositivo: dispositivo.toString(),imei: imei,marca: marca,nombreDispositivo: nombreDispositivo,token: token,sexo: '1');
        Navigator.pop(context);
        if(isOk){
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    }on ServerException catch (error){
      Navigator.pop(context);
      Dialogs.alert(context,title: 'Error', message: error.message);
    }
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
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
                        padding: EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 0.0),
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
                                        height: MediaQuery.of(context).size.height *0.92,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: new Form(
                                          key: formKey,
                                            child: new Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('Registro', style: heading35Black,
                                                      ),
                                                      new Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          TextFormField(
                                                              keyboardType: TextInputType.text,
                                                              validator: (value){
                                                                if (value.isEmpty) return 'El nombre es obligatorio.';
                                                                final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
                                                                if (!nameExp.hasMatch(value)){
                                                                  return 'Por favor ingrese solo caracteres.';
                                                                }else{
                                                                  _nombres = value;
                                                                }
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                prefixIcon: Icon(Icons.account_circle,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'Nombres',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),

                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          TextFormField(
                                                              keyboardType: TextInputType.text,
                                                              validator: (value){
                                                                if (value.isEmpty) return 'El apellido paterno es obligatorio.';
                                                                final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
                                                                if (!nameExp.hasMatch(value)){
                                                                  return 'Por favor ingrese solo caracteres.';
                                                                }else{
                                                                  _apellidoP = value;
                                                                }
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                  prefixIcon: Icon(Icons.account_circle,
                                                                      color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                  hintText: 'Apellido Paterno',
                                                                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          TextFormField(
                                                              keyboardType: TextInputType.text,
                                                              validator: (value){
                                                                if (value.isEmpty) return 'El apellido materno es obligatorio.';
                                                                final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
                                                                if (!nameExp.hasMatch(value)){
                                                                  return 'Por favor ingrese solo caracteres.';
                                                                }else{
                                                                  _apellidoM = value;
                                                                }
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                prefixIcon: Icon(Icons.account_circle,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'ApellidoMaterno',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),

                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          TextFormField(
                                                              keyboardType: TextInputType.number,
                                                              validator: (value){
                                                                if (value.isEmpty) return 'El documento de identidad es obligatorio.';
                                                                else _dni = value;
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                prefixIcon: Icon(Icons.phone,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'Documento de identidad',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                                            
                                                              )
                                                          ),
                                                          //TODO implementar sexo
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          FutureBuilder<List<Datum>>(
                                                            future: tablaApi.getSexo(context),
                                                            builder: (context, snapshot) {
                                                                if(snapshot.hasData){
                                                                  final dato = snapshot.data;
                                                                  return Container(
                                                                    width: double.infinity,
                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                        border: Border.all()),
                                                                    child:  DropdownButton(
                                                                      value: _selectedSexo,
                                                                          items: snapshot.data
                                                                            .map((sexo) => DropdownMenuItem(
                                                                                  child: Text(sexo.vchNombreCodigo),
                                                                                  value: sexo.vchValor,
                                                                                ))
                                                                            .toList(),
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              _selectedSexo = value;
                                                                            }
                                                                          );
                                                                        }
                                                                      ),
                                                                  );
                                                                }else{
                                                                return Center(child: CircularProgressIndicator(),);
                                                              }
                                                            },
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          TextFormField(
                                                              keyboardType: TextInputType.text,
                    
                                                              validator: (value){
                                                                if (value.isEmpty) return 'La direccion es obligatorio.';
                                                                else _direccion = value;
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                prefixIcon: Icon(Icons.email,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'Dirección',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                                                
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          TextFormField(
                                                              keyboardType: TextInputType.text,
                                                              validator: (value){
                                                                if (value.isEmpty) return 'La referencia es obligatorio.';
                                                                else _referencia = value;
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                prefixIcon: Icon(Icons.email,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'Referencia',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                                            
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          TextFormField(
                                                              keyboardType: TextInputType.text,
                                                              validator: (value){
                                                                if (value.length != 9)
                                                                  return 'El numero de celular debe tener 9 dígitos';
                                                                else
                                                                  _celular = value;
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                prefixIcon: Icon(Icons.phone,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'Celular',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                                            
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: <Widget>[
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Container(
                                                                    padding: EdgeInsets.only(right: 10.0),
                                                                    child: Text(
                                                                      "Fecha de nacimiento",
                                                                      style: textStyle,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 4,
                                                                  child:  GestureDetector(
                                                                      onTap: () {
                                                                        showCupertinoModalPopup<void>(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return _buildBottomPicker(
                                                                              CupertinoDatePicker(
                                                                                mode: CupertinoDatePickerMode.date,
                                                                                initialDateTime: date,
                                                                                onDateTimeChanged: (DateTime newDateTime) {
                                                                                  setState(() {
                                                                                    date = newDateTime;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: InputDropdown(
                                                                        valueText: DateFormat.yMMMMd().format(date),
                                                                        valueStyle: TextStyle(color: blackColor),
                                                                      )
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
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
                                                                prefixIcon: Icon(Icons.email,
                                                                    color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                                contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                                hintText: 'Correo',
                                                                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),

                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0),
                                                          ),
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
                                                                prefixIcon: Icon(Icons.email,
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
                                                      Padding(
                                                            padding: EdgeInsets.only(top: 10.0),
                                                          ),
                                                      new Container(
                                                          child: new Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              InkWell(
                                                                child: new Text("¿Olvido contraseña?",style: textStyleActive,),
                                                              ),
                                                            ],
                                                          )

                                                      ),
                                                      Padding(
                                                            padding: EdgeInsets.only(top: 10.0),
                                                          ),
                                                      new ButtonTheme(
                                                        height: 50.0,
                                                        minWidth: MediaQuery.of(context).size.width,
                                                        child: RaisedButton.icon(
                                                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                                                          elevation: 0.0,
                                                          color: primaryColor,
                                                          icon: new Text(''),
                                                          label: new Text('Registrarse', style: headingWhite,),
                                                          onPressed: (){
                                                            _submit();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                                new Container(
                                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text("¿Ya tienes una cuenta? ",style: textGrey,),
                                        new InkWell(
                                          onTap: () => Navigator.of(context).pushNamed(AppRoute.loginScreen),
                                          child: new Text("Iniciar sesión",style: textStyleActive,),
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

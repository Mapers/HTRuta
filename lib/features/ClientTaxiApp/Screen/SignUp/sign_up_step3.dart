import 'dart:io';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/app_router.dart';
import 'package:device_info/device_info.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';

class SignUpStep3 extends StatefulWidget {
  final String phoneNumber;
  final String validationCode;
  SignUpStep3({this.phoneNumber = '', this.validationCode});

  @override
  _SignUpStep3State createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3> {
  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();

  String names = '';
  String fatherName = '';
  String motherName = '';
  String documentNumber = ''; 
  String genderSelected = 'Masculino';

  final authApi = AuthApi();
  bool lookingData = false;
  final _prefs = UserPreferences();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();

  @override
  void dispose() { 
    nameController?.dispose();
    fatherNameController?.dispose();
    motherNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
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
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: mqHeigth(context, 20),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    elevation: 5.0,
                    child:  Form(
                      key: formKey,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Datos personales', style: headingBlack),
                                ],
                              ),
                              Container(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: mqWidth(context, 60),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (value){
                                        if (value.isEmpty) return 'El documento de identidad es obligatorio.';
                                        else documentNumber = value;
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        prefixIcon: Icon(Icons.upload_file,
                                            color: yellowClear, size: 20.0),
                                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                        hintText: 'Doc de identidad',
                                        hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                      ),
                                      onChanged: (value){
                                        documentNumber = value;
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    child: Text('Buscar', style: TextStyle(color: !lookingData ? primaryColor: Colors.grey)),
                                    onPressed: () async {
                                      if(lookingData) return;
                                      if(documentNumber.length != 8 || int.tryParse(documentNumber) == null){
                                        Dialogs.alert(context,title: 'Atención', message: 'Ingrese un dni válido');
                                        return;
                                      }
                                      lookingData = true;
                                      setState(() {});
                                      final personData = await authApi.getPersonData(documentNumber);
                                      if(personData == null){
                                        Dialogs.alert(context,title: 'Lo sentimos', message: 'No se pudo encontrar sus nombres y apellidos, ingréselo manualmente');
                                        return;
                                      }
                                      nameController.text = capitalizeFirstLetters(personData.data.nombres);
                                      names = nameController.text;
                                      fatherNameController.text = capitalizeFirstLetters(personData.data.apellidoPaterno);
                                      fatherName = fatherNameController.text;
                                      motherNameController.text = capitalizeFirstLetters(personData.data.apellidoMaterno);
                                      motherName = motherNameController.text;
                                      lookingData = false;
                                      setState(() {});
                                    }
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              ),
                              TextFormField(
                                enabled: false,
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                  if (value.isEmpty) return 'El nombre es obligatorio.';
                                  final RegExp nameExp =  RegExp(r'^[A-za-z ]+$');
                                  if (!nameExp.hasMatch(value)){
                                    return 'Por favor ingrese solo caracteres.';
                                  }else{
                                    names = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(Icons.account_circle,
                                      color: yellowClear, size: 20.0),
                                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                  hintText: 'Nombres',
                                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                ),
                                onChanged: (value){
                                  names = value;
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              ),
                              TextFormField(
                                enabled: false,
                                controller: fatherNameController,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                  if (value.isEmpty) return 'El apellido paterno es obligatorio.';
                                  final RegExp nameExp =  RegExp(r'^[A-za-z ]+$');
                                  if (!nameExp.hasMatch(value)){
                                    return 'Por favor ingrese solo caracteres.';
                                  }else{
                                    fatherName = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(Icons.account_circle,
                                      color: yellowClear, size: 20.0),
                                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                  hintText: 'Apellido paterno',
                                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                ),
                                onChanged: (value){
                                  fatherName = value;
                                },
                                ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              ),
                              TextFormField(
                                enabled: false,
                                controller: motherNameController,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                  if (value.isEmpty) return 'El apellido materno es obligatorio.';
                                  final RegExp nameExp =  RegExp(r'^[A-za-z ]+$');
                                  if (!nameExp.hasMatch(value)){
                                    return 'Por favor ingrese solo caracteres.';
                                  }else{
                                    motherName = value;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: yellowClear, size: 20.0
                                  ),
                                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                  hintText: 'Apellido materno',
                                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                                ),
                                onChanged: (value){
                                  motherName = value;
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                              ),
                              /* DropdownInput(
                                value: genderSelected,
                                items: ['Masculino', 'Femenino'],
                                hintText: 'Género',
                                onSelection: (value){
                                  genderSelected = value;
                                },
                              ), */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      genderSelected = 'Masculino';
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: mqWidth(context, 38),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: genderSelected == 'Masculino' ? Theme.of(context).primaryColor: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10)
                                        ),
                                        border: Border.all(
                                          color: Colors.black26,
                                          width: genderSelected == 'Masculino' ? 0.0 : 1.0
                                        )
                                      ),
                                      child: Center(child: Text('Masculino', style: TextStyle(color: genderSelected == 'Masculino' ? Colors.white : Theme.of(context).primaryColor, fontWeight: FontWeight.bold)))
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      genderSelected = 'Femenino';
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: mqWidth(context, 38),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: genderSelected == 'Femenino' ? Theme.of(context).primaryColor: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10)
                                        ),
                                        border: Border.all(
                                          color: Colors.black26,
                                          width: genderSelected == 'Femenino' ? 0.0 : 1.0
                                        )
                                      ),
                                      child: Center(child: Text('Femenino', style: TextStyle(color: genderSelected == 'Femenino' ? Colors.white : Theme.of(context).primaryColor, fontWeight: FontWeight.bold)))
                                    ),
                                  ),
                                ],
                              ),
                              Padding( padding: EdgeInsets.only(top: 40.0),),
                              ButtonTheme(
                                height: 50.0,
                                minWidth: MediaQuery.of(context).size.width,
                                child: RaisedButton.icon(
                                  shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15.0)),
                                  elevation: 0.0,
                                  color: primaryColor,
                                  icon:  Text(''),
                                  label:  Text('Continuar', style: headingWhite,),
                                  onPressed: () async {
                                    if(formKey.currentState.validate()){
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
                                      final token = await _prefs.tokenPush;
                                      Dialogs.openLoadingDialog(context);
                                      final isOk = await authApi.registerUser(
                                        context,
                                        dni: documentNumber,
                                        nombre: names,
                                        apellidoPaterno: fatherName,
                                        apellidoMaterno: motherName,
                                        celular: widget.phoneNumber,
                                        correo: '',
                                        password: '',
                                        direccion: '',
                                        fechaNacimiento: '',
                                        referencia: '',
                                        tipoDispositivo: dispositivo.toString(),
                                        imei: imei,
                                        marca: marca,
                                        nombreDispositivo: nombreDispositivo,
                                        token: token, 
                                        sexo: genderSelected == 'Masculino' ? '1' : '2',
                                        code: widget.validationCode
                                      );
                                      Navigator.pop(context);
                                      if(isOk){
                                        Navigator.pushNamedAndRemoveUntil(context, AppRoute.splashScreen, (route) => false);
                                      }else{
                                        Dialogs.alert(context,title: 'Error', message: 'No se pudo registrarlo');
                                      }
                                    }
                                  }
                                ),
                              ),
                            ]
                          ),
                        )                                            
                      )
                    )
                  )
                ]
              )
            ]
          )
        )
      )
    );                                                                   
  }
 /*  String capitalizeFirstLetters(String value){
    if(value == null) return '';
    if(value.isEmpty) return '';
    if(!value.contains(' ')) return inCaps(value);
    String finalWord = '';
    List<String> words = value.split(' ');
    for(String word in words){
      finalWord += inCaps(word);
    }
    return finalWord;
  } */
  String capitalizeFirstLetters(String value){
    return value.replaceAll(RegExp(' +'), ' ').split(' ').map((str) => inCaps(str)).join(' ');
  }
  String inCaps(String value){
    return value.isNotEmpty ?'${value[0].toUpperCase()}${value.toLowerCase().substring(1)}':'';
  }
}
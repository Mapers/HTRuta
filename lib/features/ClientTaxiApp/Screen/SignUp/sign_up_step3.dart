import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/sign_up_step4.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/dropdown_input.dart';

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
                              DropdownInput(
                                value: genderSelected,
                                items: ['Masculino', 'Femenino'],
                                hintText: 'Género',
                                onSelection: (value){
                                  genderSelected = value;
                                },
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
                                  onPressed: () => {
                                    if(formKey.currentState.validate()){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => 
                                        SignUpStep4(
                                          phoneNumber: widget.phoneNumber,
                                          documentNumber: documentNumber, 
                                          names: names, 
                                          fatherName: fatherName, 
                                          motherName: motherName, 
                                          gender: genderSelected,
                                          validationCode: widget.validationCode 
                                        ))
                                      )
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
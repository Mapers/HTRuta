import 'dart:async';
import 'dart:io';

import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app_router.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/select_address.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:geolocator/geolocator.dart';

class SignUpStep4 extends StatefulWidget {
  final String phoneNumber;
  final String documentNumber;
  final String names;
  final String fatherName;
  final String motherName;
  final String gender;
  final String validationCode;

  const SignUpStep4({this.phoneNumber, this.documentNumber, this.names, this.fatherName, this.motherName, this.gender, this.validationCode});

  @override
  _SignUpStep4State createState() => _SignUpStep4State();
}

class _SignUpStep4State extends State<SignUpStep4> {
  String address = '';
  final authApi = AuthApi();
  final TextEditingController addressController = TextEditingController();
  Timer _timer;
  Position currentLocation;
  final pickUpApi = PickupApi();
  List<Place> placesList = [];
  final _prefs = UserPreferences();
  
  @override
  void dispose() { 
    addressController?.dispose();
    super.dispose();
  }
  @override
  void initState() {
    Geolocator.getCurrentPosition().then((location) => {
      currentLocation = location
    });
    super.initState();
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
                  height: mqHeigth(context, 90),
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: mqHeigth(context, 5),
                    bottom: mqHeigth(context, 5),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    elevation: 5.0,
                    child:  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Selecciona tu dirección', style: headingBlack),
                            ],
                          ),
                          Container(height: 20),
                          TextFormField(
                            controller: addressController,
                            validator: (value){
                              if (value.isEmpty) return 'La dirección es obligatoria.';
                              else address = value;
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: Icon(Icons.upload_file,
                                  color: yellowClear, size: 20.0),
                              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                              hintText: 'Dirección',
                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand'),
                            ),
                            onChanged: (value){
                              address = value;
                              _timer?.cancel();
                              _timer = Timer(const Duration(milliseconds: 1000), ()async{
                                if(currentLocation == null) return;
                                placesList = await pickUpApi.searchPlaces(address, currentLocation);
                                setState(() {});
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.place, color: Theme.of(context).primaryColor),
                            title: Text('Seleccionar punto en el mapa', style: TextStyle(color: Theme.of(context).primaryColor)),
                            onTap: () async {
                              final Place placeSelected = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectAddress()));
                              if(placeSelected == null) return;
                              addressController.text = placeSelected.name;
                              address = placeSelected.name;
                            }
                          ),
                          //Hacer la lista
                          Padding( padding: EdgeInsets.only(top: 40.0),),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: placesList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(placesList[index].name),
                                  subtitle: Text(placesList[index].formattedAddress),
                                  onTap: () {
                                    addressController.text = placesList[index].name;
                                    address = placesList[index].name;
                                    placesList = [];
                                    setState(() {});
                                  }
                                );
                              },
                              separatorBuilder: (context, index) => const Divider(
                                height: 1,
                                color: Colors.grey
                              ),
                            ),
                          ),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: MediaQuery.of(context).size.width,
                            child: RaisedButton.icon(
                              shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15.0)),
                              elevation: 0.0,
                              color: primaryColor,
                              icon:  Text(''),
                              label:  Text('Finalizar', style: headingWhite,),
                              onPressed: () async {
                                if(address.isEmpty) {
                                  Dialogs.alert(context, title: 'Atención', message: 'Seleccione su dirección');
                                  return;
                                }
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
                                  dni: widget.documentNumber,
                                  nombre: widget.names,
                                  apellidoPaterno: widget.fatherName,
                                  apellidoMaterno: widget.motherName,
                                  celular: widget.phoneNumber,
                                  correo: '',
                                  password: '',
                                  direccion: address,
                                  fechaNacimiento: '',
                                  referencia: '',
                                  tipoDispositivo: dispositivo.toString(),
                                  imei: imei,
                                  marca: marca,
                                  nombreDispositivo: nombreDispositivo,
                                  token: token, 
                                  sexo: widget.gender == 'Masculino' ? '1' : '2',
                                  code: widget.validationCode
                                );
                                Navigator.pop(context);
                                if(isOk){
                                  Navigator.pushNamedAndRemoveUntil(context, AppRoute.splashScreen, (route) => false);
                                }else{
                                  Dialogs.alert(context,title: 'Error', message: 'No se pudo registrarlo');
                                }
                              }
                            ),
                          ),
                          ]
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
}
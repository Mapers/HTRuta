import 'dart:convert';

import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/usuario_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/response/driver_data_response.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AuthApi{

  Future<bool> registerUser(BuildContext context, {String dni,String nombre,String apellidoPaterno, String apellidoMaterno,String fechaNacimiento, String sexo, String direccion, String referencia, String celular, String correo, String password, String tipoDispositivo,String marca, String nombreDispositivo, String imei, String token}) async{
    final url = '${Config.apiHost}/api_setRegistroUsuario.php?Dni=$dni&Nombre=$nombre&ApellidoP=$apellidoPaterno&ApellidoM=$apellidoMaterno&FecNac=$fechaNacimiento&Sexo=$sexo&Dirección=$direccion&Referencia=$referencia&Telefono=''&Celular=$celular&Correo=$correo&Password=$password&iTipoDispositivo=$tipoDispositivo&iMarca=$marca&vchNombreD=$nombreDispositivo&Imei=$imei&TokenD=$token';

    return Future<bool>.sync(() {
      return http.post(url,body: {'Dni' : dni, 'Nombre': nombre, 'ApellidoP': apellidoPaterno, 'ApellidoM': apellidoMaterno,'FecNac': fechaNacimiento,'Sexo': sexo,'Dirección': direccion,'Referencia': referencia,'Telefono': '','Celular': celular,'Correo': correo,'Password': password,'iTipoDispositivo': tipoDispositivo,'iMarca': marca,'vchNombreD': nombreDispositivo,'Imei': imei,'TokenD': token} ).then((response)async{
        Map<String,dynamic> usuarioResponse = json.decode(response.body);
        if(usuarioResponse != null){
          if(usuarioResponse['success']){
            final urlLogin = '${Config.apiHost}/api_getLoginUsuario.php?email=$correo&clave=$password&tipo=1';
            final response = await http.post(urlLogin,body: {'email' : correo, 'clave' : password, 'tipo' : '1'});
            final responseLogin = userModelFromJson(response.body);
            final usuario = responseLogin.data;
            final session = Session();
            await session.set(usuario.iIdUsuario.toString(),dni, nombre, apellidoPaterno, apellidoMaterno, celular,correo, password, usuario.urlImage, usuario.sexo, '123456');//TODO: Poner el valor real
            return true;
          }else{
            Dialogs.alert(context,title: 'Error',message: usuarioResponse['message']);
            return false;
          }
        }else{
          Dialogs.alert(context,title: 'Error',message: 'Ocurrio un error con el servidor, volver a intentar');
          return false;
        }
      }).catchError((onError){
        Dialogs.alert(context,title: 'Error',message: 'Ocurrio un error con el servidor, volver a intentar');
      });
    }).catchError((onError){
      Dialogs.alert(context,title: 'Error',message: 'Ocurrio un error con el servidor, volver a intentar');
    });
  }

  /* Future<bool> loginUser(String email, String password) async{
    final _prefs = UserPreferences();
    await _prefs.initPrefs();
    final token = await _prefs.tokenPush;
    final url = '${Config.apiHost}/api_getLoginUsuario.php?email=$email&clave=$password&tipo=1&token=$token';
    final response = await http.post(url,body: {'email' : email, 'clave' : password, 'tipo' : '1', 'token' : token});
    print(response.body);
    final responseUsuario = userModelFromJson(response.body);
    if(responseUsuario.success){
      final usuario = responseUsuario.data[0];
      final session = Session();
      _prefs.idUsuario = usuario.iIdUsuario.toString();
      await session.set(usuario.iIdUsuario.toString(),usuario.vchDni, usuario.vchNombres, usuario.vchApellidoP, usuario.vchApellidoM, usuario.vchCelular,usuario.vchCorreo, usuario.vchPassword, usuario.urlImage, usuario.sexo);
      if(responseUsuario.data.length > 1){
        if(responseUsuario.data[1] != null){
          final url = '${Config.nuevaRutaApi}/chofer/obtener-informacion-personal?choferId=${responseUsuario.data[1].iIdChofer}';
          final response = await http.get(url);
          DriverDataResponse driverDataResponse = driverDataResponseFromJson(response.body);
          await session.setDriverData(responseUsuario.data[1].vchNombres, responseUsuario.data[1].vchApellidoP, responseUsuario.data[1].vchApellidoM, responseUsuario.data[1].vchCelular, responseUsuario.data[1].vchCorreo, responseUsuario.data[1].vchDni, driverDataResponse.data.sexo, driverDataResponse.data.fechaNacimiento.toString(), driverDataResponse.data.fechaRegistro.toString(), driverDataResponse.data.urlImage);
          final _prefs = UserPreferences();
          await _prefs.initPrefs();
          _prefs.idChofer = responseUsuario.data[1].iIdUsuario.toString();
          _prefs.idChoferReal = responseUsuario.data[1].iIdChofer.toString();
        }
      }
      return true;
    }
    throw ServerException(message: 'Ocurrió un error con el servidor');
  } */
  Future<bool> loginUserSMS(String phoneNumber, String code) async{
    final _prefs = UserPreferences();
    await _prefs.initPrefs();
    final token = await _prefs.tokenPush;
    final url = 'http://23.254.217.21:8000/api/auth/login';
    final response = await http.post(url,body: {'cellphone' : phoneNumber, 'code' : code, 'token': _prefs.tokenPush});
    print(response.body);
    final responseUsuario = userModelFromJson(response.body);
    if(responseUsuario.success){
      final usuario = responseUsuario.data;
      final session = Session();
      _prefs.idUsuario = usuario.iIdUsuario.toString();
      await session.set(usuario.iIdUsuario.toString(),usuario.vchDni, usuario.vchNombres, usuario.vchApellidoP, usuario.vchApellidoM, usuario.vchCelular,usuario.vchCorreo, usuario.vchPassword, usuario.urlImage, usuario.sexo, code);
      if(responseUsuario.data.iIdChofer != 0){
        final url = '${Config.nuevaRutaApi}/chofer/obtener-informacion-personal?choferId=${responseUsuario.data.iIdChofer}';
        final response = await http.get(url);
        DriverDataResponse driverDataResponse = driverDataResponseFromJson(response.body);
        await session.setDriverData(responseUsuario.data.vchNombres, responseUsuario.data.vchApellidoP, responseUsuario.data.vchApellidoM, responseUsuario.data.vchCelular, responseUsuario.data.vchCorreo, responseUsuario.data.vchDni, driverDataResponse.data.sexo, driverDataResponse.data.fechaNacimiento.toString(), driverDataResponse.data.fechaRegistro.toString(), driverDataResponse.data.urlImage, code);
        _prefs.idChofer = responseUsuario.data.iIdUsuario.toString();
        _prefs.idChoferReal = responseUsuario.data.iIdChofer.toString();
      }
      return true;
    }
    throw ServerException(message: 'Ocurrió un error con el servidor');
  }
  Future<bool> getVerificationCode(String phoneNumber) async {
    try{
      final response = await http.post('http://23.254.217.21:8000/api/auth/send-code/sms', body: {'cellphone' : phoneNumber});
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        if(data['success']){
          return true;
        }
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
    
  }
}
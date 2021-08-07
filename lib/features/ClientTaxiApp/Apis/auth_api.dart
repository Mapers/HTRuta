import 'dart:convert';

import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/person_data_response.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/usuario_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/response/driver_data_response.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthApi{

  Future<bool> registerUser(BuildContext context, {String dni,String nombre,String apellidoPaterno, String apellidoMaterno,String fechaNacimiento, String sexo, String direccion, String referencia, String celular, String correo, String password, String tipoDispositivo,String marca, String nombreDispositivo, String imei, String token, String code}) async{
    final url = '${Config.apiHost}/api_setRegistroUsuario.php?Dni=$dni&Nombre=$nombre&ApellidoP=$apellidoPaterno&ApellidoM=$apellidoMaterno&FecNac=$fechaNacimiento&Sexo=$sexo&Dirección=$direccion&Referencia=$referencia&Telefono=''&Celular=$celular&Correo=$correo&Password=$password&iTipoDispositivo=$tipoDispositivo&iMarca=$marca&vchNombreD=$nombreDispositivo&Imei=$imei&TokenD=$token&codeVerification=$code';
    Response response;
    try{
      response = await http.post(url,body: {'Dni' : dni, 'Nombre': nombre, 'ApellidoP': apellidoPaterno, 'ApellidoM': apellidoMaterno,'FecNac': fechaNacimiento,'Sexo': sexo,'Dirección': direccion,'Referencia': referencia,'Telefono': '','Celular': celular,'Correo': correo,'Password': password,'iTipoDispositivo': tipoDispositivo,'iMarca': marca,'vchNombreD': nombreDispositivo,'Imei': imei,'TokenD': token, 'codeVerification': code} );  
    }catch(e){
      print(e);
      return false;
    }
    Map<String,dynamic> usuarioResponse = json.decode(response.body);
    if(usuarioResponse == null || !usuarioResponse['success']) return false;
    final urlLogin = '${Config.apiHost}/api_getLoginUsuario.php?email=$correo&clave=$password&tipo=1';
    Response responseGet;
    try{
      responseGet = await http.post(urlLogin,body: {'email' : correo, 'clave' : password, 'tipo' : '1'});
    }catch(e){
      print(e);
      return false;
    }
    final responseLogin = userModelRegisterFromJson(responseGet.body);
    final usuario = responseLogin.data;
    final session = Session();
    await session.set(usuario.iIdUsuario.toString(),dni, nombre, apellidoPaterno, apellidoMaterno, celular,correo, password, usuario.urlImage, usuario.sexo, code, usuario.fechaNacimiento, usuario.fechaRegistroUsuario, usuario.direccion, usuario.referencia);//TODO: Poner el valor real
    return true;
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
    try{
      final _prefs = UserPreferences();
      await _prefs.initPrefs();
      final token = await _prefs.tokenPush;
      final url = 'http://23.254.217.21:8000/api/auth/login';
      final response = await http.post(url,body: {'cellphone' : phoneNumber, 'code' : code, 'token': _prefs.tokenPush});
      print(response.body);
      if(response.statusCode == 200){
        final responseUsuario = userModelFromJson(response.body);
        final usuario = responseUsuario.data;
        final session = Session();
        _prefs.idUsuario = usuario.iIdUsuario.toString();
        await session.set(usuario.iIdUsuario.toString(),usuario.vchDni, usuario.vchNombres, usuario.vchApellidoP, usuario.vchApellidoM, usuario.vchCelular,usuario.vchCorreo, usuario.vchPassword, usuario.urlImage, usuario.sexo, code, usuario.fechaNacimiento, usuario.fechaRegistroUsuario, usuario.direccion, usuario.referencia);
        if(responseUsuario.data.iIdChofer != 0){
          final url = '${Config.nuevaRutaApi}/chofer/obtener-informacion-personal?choferId=${responseUsuario.data.iIdChofer}';
          final response = await http.get(url);
          DriverDataResponse driverDataResponse = driverDataResponseFromJson(response.body);
          await session.setDriverData(responseUsuario.data.vchNombres, responseUsuario.data.vchApellidoP, responseUsuario.data.vchApellidoM, responseUsuario.data.vchCelular, responseUsuario.data.vchCorreo, responseUsuario.data.vchDni, driverDataResponse.data.sexo, driverDataResponse.data.fechaNacimiento.toString(), driverDataResponse.data.fechaRegistro.toString(), driverDataResponse.data.urlImage, code, usuario.direccion, usuario.referencia, driverDataResponse.data.metodosPago, driverDataResponse.data.saldo);
          _prefs.idChofer = responseUsuario.data.iIdUsuario.toString();
          _prefs.idChoferReal = responseUsuario.data.iIdChofer.toString();
        }else{
          _prefs.idChoferReal = '0';
        }
        return true;
      }
      throw ServerException(message: 'Ocurrió un error con el servidor');  
    }catch(e){
      return false;
    }
    
  }
  Future<String> getVerificationCode(String phoneNumber) async {
    try{
      final response = await http.post('http://23.254.217.21:8000/api/auth/send-code/sms', body: {'cellphone' : phoneNumber, 'validateAuth': 'true'});
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        if(data['success']){
          return 'S'; //Login exitoso
        }
        return 'N'; //No existe la cuenta
      }else{
        return 'E'; //Error desconocido
      }
    }catch(e){
      print(e);
      return 'E';
    }
    
  }
  Future<String> getVerificationCodeRegister(String phoneNumber) async {
    try{
      final response = await http.post('http://23.254.217.21:8000/api/auth/send-code/sms', body: {'cellphone' : phoneNumber, 'validateAuth': 'false'});
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        if(data['success']){
          return data['data']['code'];
        }
        return '';
      }else{
        return '';
      }
    }catch(e){
      print(e);
      return '';
    }
  }
  Future<PersonDataResponse> getPersonData(String dni) async {
    try{
      var headers = {
        'Authorization': 'Bearer 610465b3b8bea7d58a996692a1013d2477db981006a545953e481bdbbee0dc36'
      };
      var request = http.Request('GET', Uri.parse('https://apiperu.dev/api/dni/$dni'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final data = personDataResponseFromJson(body);
        return data;
      }
      else {
        return null;
      }
    }catch(e){
      return null;
    }
  }
}
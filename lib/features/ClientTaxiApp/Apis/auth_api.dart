import 'dart:convert';

import 'package:HTRuta/features/ClientTaxiApp/Model/usuario_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';
import 'package:http/http.dart' as http;

class AuthApi{


  Future<bool> registerUser(BuildContext context, {String dni,String nombre,String apellidoPaterno, String apellidoMaterno,String fechaNacimiento, String sexo, String direccion, String referencia, String celular, String correo, String password, String tipoDispositivo,String marca, String nombreDispositivo, String imei, String token}) async{
    final url = '${Config.apiHost}/api_setRegistroUsuario.php?Dni=$dni&Nombre=$nombre&ApellidoP=$apellidoPaterno&ApellidoM=$apellidoMaterno&FecNac=$fechaNacimiento&Sexo=$sexo&Dirección=$direccion&Referencia=$referencia&Telefono=''&Celular=$celular&Correo=$correo&Password=$password&iTipoDispositivo=$tipoDispositivo&iMarca=$marca&vchNombreD=$nombreDispositivo&Imei=$imei&TokenD=$token';

    return Future<bool>.sync(() {
      return http.post(url,body: {'Dni' : dni, 'Nombre': nombre, 'ApellidoP': apellidoPaterno, 'ApellidoM': apellidoMaterno,'FecNac': fechaNacimiento,'Sexo': sexo,'Dirección': direccion,'Referencia': referencia,'Telefono': '','Celular': celular,'Correo': correo,'Password': password,'iTipoDispositivo': tipoDispositivo,'iMarca': marca,'vchNombreD': nombreDispositivo,'Imei': imei,'TokenD': token} ).then((response)async{
        print(response.body);
        Map<String,dynamic> usuarioResponse = json.decode(response.body);
        if(usuarioResponse != null){
          if(usuarioResponse['success']){
            final urlLogin = '${Config.apiHost}/api_getLoginUsuario.php?email=$correo&clave=$password&tipo=1';
            final response = await http.post(urlLogin,body: {'email' : correo, 'clave' : password, 'tipo' : '1'});
            final responseLogin = userModelFromJson(response.body);
            final usuario = responseLogin.data[0];
            final session = Session();
            await session.set(usuario.iIdUsuario.toString(),dni, nombre, apellidoPaterno, apellidoMaterno, celular,correo, password);
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
        print(onError.toString());
      });
    }).catchError((onError){
      Dialogs.alert(context,title: 'Error',message: 'Ocurrio un error con el servidor, volver a intentar');
        print(onError.toString());
    });
  }

  Future<bool> loginUser(String email, String password) async{
    final _prefs = UserPreferences();
    await _prefs.initPrefs();
    final token = await _prefs.tokenPush;
    final url = '${Config.apiHost}/api_getLoginUsuario.php?email=$email&clave=$password&tipo=1&token=$token';
    final response = await http.post(url,body: {'email' : email, 'clave' : password, 'tipo' : '1', 'token' : token});
    final responseUsuario = userModelFromJson(response.body);
    if(responseUsuario.success){
      final usuario = responseUsuario.data[0];
      final session = Session();
      await session.set(usuario.iIdUsuario.toString(),usuario.vchDni, usuario.vchNombres, usuario.vchApellidoP, usuario.vchApellidoM, usuario.vchCelular,usuario.vchCorreo, usuario.vchPassword);
      if(responseUsuario.data.length > 1){
        if(responseUsuario.data[1] != null){
          final _prefs = UserPreferences();
          await _prefs.initPrefs();
          _prefs.idChofer = responseUsuario.data[1].iIdUsuario.toString();
        }
      }
      return true;
    }
    throw ServerException(message: 'Ocurrió un error con el servidor');
  }
}
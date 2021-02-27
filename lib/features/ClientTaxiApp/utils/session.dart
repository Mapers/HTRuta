import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session{
  final key = 'SESSION';
  final storage =FlutterSecureStorage();

  set(String id,String dni, String nombres, String apellidoPaterno,String apellidoMaterno, String celular,String correo,String password) async{
    final data = {
      'id' : id,
      'dni' : dni,
      'nombres' : nombres,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno' : apellidoMaterno,
      'celular' : celular,
      'correo' : correo,
      'password' : password,
    };
    await storage.write(key: key, value: jsonEncode(data));
  }

  get() async{
    final result = await storage.read(key: key);
    if(result != null){
      return jsonDecode(result);
    }
    return null;
  }

  clear() async{
    await storage.deleteAll();
  }
}
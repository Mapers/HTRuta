import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session{
  final key = 'SESSION';
  final storage = FlutterSecureStorage();

  // ignore: always_declare_return_types
  set(String id,String dni, String names, String lastNameFather, String lastNameMother, String cellphone, String email, String password) async{
    final data = UserSession(
      id: id,
      dni: dni,
      names: names,
      lastNameFather: lastNameFather,
      lastNameMother: lastNameMother,
      cellphone: cellphone,
      email: email,
      password: password,
    );
    await storage.write(key: key, value: jsonEncode(data.toMap));
  }

  Future<UserSession> get() async{
    final result = await storage.read(key: key);
    if(result != null){
      return UserSession.fromMap(jsonDecode(result));
    }
    return null;
  }

  void clear() async => await storage.deleteAll();
}

class UserSession extends Equatable{
  final String id;
  final String dni;
  final String names;
  final String lastNameFather;
  final String lastNameMother;
  final String cellphone;
  final String email;
  final String password;

  UserSession({
    @required this.id,
    @required this.dni,
    @required this.names,
    @required this.lastNameFather,
    @required this.lastNameMother,
    @required this.cellphone,
    @required this.email,
    @required this.password
  });

  Map<String, String> get toMap => {
    'id': id,
    'dni': dni,
    'names': names,
    'last_name_father': lastNameFather,
    'last_name_mother': lastNameMother,
    'cellphone': cellphone,
    'email': email,
    'password': password
  };

  String get fullNames => '$lastNameFather $lastNameMother $names';

  factory UserSession.fromMap(dynamic json) => UserSession(
    id: json['id'],
    dni: json['dni'],
    names: json['names'],
    lastNameFather: json['last_name_father'],
    lastNameMother: json['last_name_mother'],
    cellphone: json['cellphone'],
    email: json['email'],
    password: json['password']
  );

  @override
  List<Object> get props => [id, dni, names, lastNameFather, lastNameMother, cellphone, email, password];
}
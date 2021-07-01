import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session{
  final key = 'SESSION';
  final storage = FlutterSecureStorage();

  // ignore: always_declare_return_types
  set(String id,String dni, String names, String lastNameFather, String lastNameMother, String cellphone, String email, String password, String imageUrl, String sexo) async{
    final data = UserSession(
      id: id,
      dni: dni,
      names: names,
      lastNameFather: lastNameFather,
      lastNameMother: lastNameMother,
      cellphone: cellphone,
      email: email,
      password: password,
      imageUrl: imageUrl,
      sexo: sexo,
    );
    await storage.write(key: key, value: jsonEncode(data.toMap));
  }

  void setDriverData(String name, String pName, String mName, String phone, String email, String dni, String sexo, String fechaNacimiento, String fechaRegistro, String imageUrl) async{
    final data = DriverSession(
      name: name,
      pName: pName,
      mName: mName,
      phone: phone,
      email: email,
      dni: dni,
      sexo: sexo,
      fechaNacimiento: fechaNacimiento,
      fechaRegistro: fechaRegistro,
      imageUrl: imageUrl
    );
    await storage.write(key: 'DRIVER', value: jsonEncode(data.toMap));
  }

  Future<UserSession> get() async{
    final result = await storage.read(key: key);
    if(result != null){
      return UserSession.fromMap(jsonDecode(result));
    }
    return null;
  }

  Future<DriverSession> getDriverData() async{
    final result = await storage.read(key: 'DRIVER');
    if(result != null){
      return DriverSession.fromMap(jsonDecode(result));
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
  final String imageUrl;
  final String sexo;

  UserSession({
    @required this.id,
    @required this.dni,
    @required this.names,
    @required this.lastNameFather,
    @required this.lastNameMother,
    @required this.cellphone,
    @required this.email,
    @required this.password,
    @required this.imageUrl,
    @required this.sexo
  });

  Map<String, String> get toMap => {
    'id': id,
    'dni': dni,
    'names': names,
    'last_name_father': lastNameFather,
    'last_name_mother': lastNameMother,
    'cellphone': cellphone,
    'email': email,
    'password': password,
    'imageUrl': imageUrl,
    'sexo': sexo
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
    password: json['password'],
    imageUrl: json['imageUrl'],
    sexo: json['sexo']
  );

  @override
  List<Object> get props => [id, dni, names, lastNameFather, lastNameMother, cellphone, email, password, imageUrl, sexo];
}

class DriverSession extends Equatable{
  final String name;
  final String pName;
  final String mName;
  final String phone;
  final String email;
  final String dni;
  final String sexo;
  final String fechaNacimiento;
  final String fechaRegistro;
  final String imageUrl;

  DriverSession({
    @required this.name,
    @required this.pName,
    @required this.mName,
    @required this.phone,
    @required this.email,
    @required this.dni,
    @required this.sexo,
    @required this.fechaNacimiento,
    @required this.fechaRegistro,
    @required this.imageUrl,
  });

  Map<String, String> get toMap => {
    'name': name,
    'pName': pName,
    'mName': mName,
    'phone': phone,
    'email': email,
    'dni': dni,
    'sexo': sexo,
    'fechaNacimiento': fechaNacimiento,
    'fechaRegistro': fechaRegistro,
    'imageUrl': imageUrl,
  };

  factory DriverSession.fromMap(dynamic json) => DriverSession(
    name: json['name'],
    pName: json['pName'],
    mName: json['mName'],
    phone: json['phone'],
    email: json['email'],
    dni: json['dnir'],
    sexo: json['sexo'],
    fechaNacimiento: json['fechaNacimiento'],
    fechaRegistro: json['fechaRegistro'],
    imageUrl: json['imageUrl']
  );

  @override
  List<Object> get props => [name, pName, mName, phone, email, dni, sexo, fechaNacimiento, fechaRegistro, imageUrl];
}
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session{
  final key = 'SESSION';
  final storage = FlutterSecureStorage();

  // ignore: always_declare_return_types
  set(String id,String dni, String names, String lastNameFather, String lastNameMother, String cellphone, String email, String password, String imageUrl, String sexo, String smsCode, String fechaNacimiento, String fechaRegistro, String direccion, String referencia) async{
    final data = UserSession(
      id: id,
      dni: dni,
      names: names,
      lastNameFather: lastNameFather,
      lastNameMother: lastNameMother,
      cellphone: cellphone,
      smsCode: smsCode,
      email: email,
      password: password,
      imageUrl: imageUrl,
      sexo: sexo,
      fechaNacimiento: fechaNacimiento,
      fechaRegistro: fechaRegistro,
      direccion: direccion,
      referencia: referencia,
    );
    await storage.write(key: key, value: jsonEncode(data.toMap));
  }

  void setDriverData(String name, String pName, String mName, String phone, String email, String dni, String sexo, String fechaNacimiento, String fechaRegistro, String imageUrl, String smsCode, String direccion, String referencia, String metodosPago, double saldo) async{
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
      imageUrl: imageUrl,
      smsCode: smsCode,
      direccion: direccion,
      referencia: referencia,
      metodosPago: metodosPago,
      saldo: saldo
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
  final String smsCode;
  final String fechaRegistro;
  final String fechaNacimiento;
  final String direccion;
  final String referencia;

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
    @required this.sexo,
    @required this.smsCode,
    @required this.fechaRegistro,
    @required this.fechaNacimiento,
    @required this.direccion,
    @required this.referencia,
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
    'sexo': sexo,
    'smsCode': smsCode,
    'fechaRegistro': fechaRegistro,
    'fechaNacimiento': fechaNacimiento,
    'direccion': direccion,
    'referencia': referencia,
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
    sexo: json['sexo'],
    smsCode: json['smsCode'],
    fechaRegistro: json['fechaRegistro'],
    fechaNacimiento: json['fechaNacimiento'],
    direccion: json['direccion'],
    referencia: json['referencia'],
  );

  @override
  List<Object> get props => [id, dni, names, lastNameFather, lastNameMother, cellphone, email, password, imageUrl, sexo, smsCode, fechaRegistro, fechaNacimiento, direccion, referencia];
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
  final String smsCode;
  final String direccion;
  final String referencia;
  final String metodosPago;
  final double saldo;
  

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
    @required this.smsCode,
    @required this.direccion,
    @required this.referencia,
    @required this.metodosPago,
    @required this.saldo,
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
    'smsCode': smsCode,
    'direccion': direccion,
    'referencia': referencia,
    'metodos_pago': metodosPago,
    'saldo': saldo.toString(),
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
    imageUrl: json['imageUrl'],
    smsCode: json['smsCode'],
    direccion: json['direccion'],
    referencia: json['referencia'],
    metodosPago: json['metodos_pago'] ?? 'false',
    saldo: json['saldo'] != null ? double.parse(json['saldo']) : 0.0,
  );

  @override
  List<Object> get props => [name, pName, mName, phone, email, dni, sexo, fechaNacimiento, fechaRegistro, imageUrl, smsCode, direccion, referencia, metodosPago, saldo];
}
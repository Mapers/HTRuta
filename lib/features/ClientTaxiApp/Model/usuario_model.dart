// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.message,
    this.success,
    this.data,
  });

  String message;
  bool success;
  List<UserEntity> data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    message: json['message'],
    success: json['success'],
    data: List<UserEntity>.from(json['data'].map((x) => UserEntity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserEntity {
  UserEntity({
    this.bAdministrador,
    this.bInactivo,
    this.vchDni,
    this.vchNombres,
    this.vchApellidoP,
    this.vchApellidoM,
    this.vchCelular,
    this.vchCorreo,
    this.vchPassword,
    this.iIdUsuario
  });

  int bAdministrador;
  int bInactivo;
  String vchDni;
  String vchNombres;
  String vchApellidoP;
  String vchApellidoM;
  String vchCelular;
  String vchCorreo;
  String vchPassword;
  int iIdUsuario;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    bAdministrador: json['bAdministrador'],
    bInactivo: json['bInactivo'],
    vchDni: json['vchDni'],
    vchNombres: json['vchNombres'],
    vchApellidoP: json['vchApellidoP'],
    vchApellidoM: json['vchApellidoM'],
    vchCelular: json['vchCelular'],
    vchCorreo: json['vchCorreo'],
    vchPassword: json['vchPassword'],
    iIdUsuario: json['iIdUsuario']
  );

  Map<String, dynamic> toJson() => {
    'bAdministrador': bAdministrador,
    'bInactivo': bInactivo,
    'vchDni': vchDni,
    'vchNombres': vchNombres,
    'vchApellidoP': vchApellidoP,
    'vchApellidoM': vchApellidoM,
    'vchCelular': vchCelular,
    'vchCorreo': vchCorreo,
    'vchPassword': vchPassword,
    'iIdUsuario' : iIdUsuario
  };
}
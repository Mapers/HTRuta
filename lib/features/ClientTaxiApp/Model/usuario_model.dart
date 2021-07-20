// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
UserModel userModelRegisterFromJson(String str) => UserModel.fromJsonList(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.message,
    this.success,
    this.data,
  });

  String message;
  bool success;
  UserEntity data;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    message: json['message'],
    success: json['success'],
    data: UserEntity.fromJson(json['data'])
  );
  factory UserModel.fromJsonList(Map<String, dynamic> json) => UserModel(
    message: json['message'],
    success: json['success'],
    data: UserEntity.fromJsonList(json['data'][0])
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    'data': data.toJson(),
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
    this.urlImage,
    this.sexo,
    this.iIdUsuario,
    this.iIdChofer,
    this.fechaNacimiento,
    this.fechaRegistroUsuario,
    this.fechaRegistroChofer,
    this.direccion,
    this.referencia
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
  String urlImage;
  String sexo;
  int iIdUsuario;
  int iIdChofer;
  String fechaNacimiento;
  String fechaRegistroUsuario;
  String fechaRegistroChofer;
  String direccion;
  String referencia;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    bAdministrador: json['bAdministrador'] != null ? int.parse(json['bAdministrador'].toString()) : 0,
    bInactivo: json['bInactivo'] != null ? int.parse(json['bInactivo'].toString()) : 0,
    vchDni: json['vchDni'],
    vchNombres: json['vchNombres'],
    vchApellidoP: json['vchApellidoP'],
    vchApellidoM: json['vchApellidoM'],
    vchCelular: json['vchCelular'],
    vchCorreo: json['vchCorreo'],
    vchPassword: json['vchPassword'],
    urlImage: json['urlImage'] ?? '',
    fechaNacimiento: json['fechaNacimiento'] ?? '',
    fechaRegistroUsuario: json['fechaRegistroUsuario'] ?? '',
    fechaRegistroChofer: json['fechaRegistroChofer'] ?? '',
    sexo: json['sexo'].toString(),
    iIdUsuario: json['iIdUsuario'] != null ? int.parse(json['iIdUsuario'].toString()) : 0,
    iIdChofer: json['iIdChofer'] != null ? int.parse(json['iIdChofer'].toString()) : 0,
    direccion: json['direccion'] ?? '',
    referencia: json['referencia'] ?? ''
  );

  factory UserEntity.fromJsonList(Map<String, dynamic> json) => UserEntity(
    bAdministrador: json['bAdministrador'] != null ? int.parse(json['bAdministrador'].toString()) : 0,
    bInactivo: json['bInactivo'] != null ? int.parse(json['bInactivo'].toString()) : 0,
    vchDni: json['vchDni'],
    vchNombres: json['vchNombres'],
    vchApellidoP: json['vchApellidoP'],
    vchApellidoM: json['vchApellidoM'],
    vchCelular: json['vchCelular'],
    vchCorreo: json['vchCorreo'],
    vchPassword: json['vchPassword'],
    urlImage: json['urlImage'] ?? '',
    fechaNacimiento: json['fechaNacimiento'] != null ? json['fechaNacimiento']['date'].toString() : '',
    fechaRegistroUsuario: json['fechaRegistroUsuario'] != null ? json['fechaRegistroUsuario']['date'].toString() : '',
    fechaRegistroChofer: json['fechaRegistroChofer'] != null ? json['fechaRegistroChofer']['date'].toString() : '',
    sexo: json['sexo'].toString(),
    iIdUsuario: json['iIdUsuario'] != null ? int.parse(json['iIdUsuario'].toString()) : 0,
    iIdChofer: json['iIdChofer'] != null ? int.parse(json['iIdChofer'].toString()) : 0,
    direccion: json['direccion'] ?? '',
    referencia: json['referencia'] ?? ''
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
    'urlImage': urlImage,
    'sexo': sexo,
    'iIdUsuario' : iIdUsuario,
    'iIdChofer' : iIdChofer,
    'direccion': direccion,
    'referencia': referencia
  };
}
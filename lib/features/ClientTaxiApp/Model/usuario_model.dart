// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<DataUsuario> data;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        message: json["message"],
        success: json["success"],
        data: List<DataUsuario>.from(json["data"].map((x) => DataUsuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataUsuario {
    DataUsuario({
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

    factory DataUsuario.fromJson(Map<String, dynamic> json) => DataUsuario(
        bAdministrador: json["bAdministrador"],
        bInactivo: json["bInactivo"],
        vchDni: json["vchDni"],
        vchNombres: json["vchNombres"],
        vchApellidoP: json["vchApellidoP"],
        vchApellidoM: json["vchApellidoM"],
        vchCelular: json["vchCelular"],
        vchCorreo: json["vchCorreo"],
        vchPassword: json["vchPassword"],
        iIdUsuario: json["iIdUsuario"]
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



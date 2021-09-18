// To parse this JSON data, do
//
//     final appServicesResponse = appServicesResponseFromJson(jsonString);

import 'dart:convert';

AppServicesResponse appServicesResponseFromJson(String str) => AppServicesResponse.fromJson(json.decode(str));

String appServicesResponseToJson(AppServicesResponse data) => json.encode(data.toJson());

class AppServicesResponse {
    AppServicesResponse({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<AppService> data;

    factory AppServicesResponse.fromJson(Map<String, dynamic> json) => AppServicesResponse(
        message: json['message'],
        success: json['success'],
        data: List<AppService>.from(json['data'].map((x) => AppService.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class AppService {
    AppService({
        this.idFuncionalidades,
        this.tipoFuncionalidad,
        this.estado,
    });

    String idFuncionalidades;
    String tipoFuncionalidad;
    String estado;

    factory AppService.fromJson(Map<String, dynamic> json) => AppService(
        idFuncionalidades: json['idFuncionalidades'],
        tipoFuncionalidad: json['tipoFuncionalidad'],
        estado: json['estado'],
    );

    Map<String, dynamic> toJson() => {
        'idFuncionalidades': idFuncionalidades,
        'tipoFuncionalidad': tipoFuncionalidad,
        'estado': estado,
    };
}

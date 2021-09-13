// To parse this JSON data, do
//
//     final servicesResponse = servicesResponseFromJson(jsonString);

import 'dart:convert';

ServicesResponse servicesResponseFromJson(String str) => ServicesResponse.fromJson(json.decode(str));

String servicesResponseToJson(ServicesResponse data) => json.encode(data.toJson());

class ServicesResponse {
    ServicesResponse({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<ServiceAvailable> data;

    factory ServicesResponse.fromJson(Map<String, dynamic> json) => ServicesResponse(
        message: json['message'],
        success: json['success'],
        data: List<ServiceAvailable>.from(json['data'].map((x) => ServiceAvailable.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ServiceAvailable {
    ServiceAvailable({
        this.idFuncionalidades,
        this.tipoFuncionalidad,
        this.estado,
    });

    String idFuncionalidades;
    String tipoFuncionalidad;
    String estado;

    factory ServiceAvailable.fromJson(Map<String, dynamic> json) => ServiceAvailable(
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

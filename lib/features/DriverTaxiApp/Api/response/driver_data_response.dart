// To parse this JSON data, do
//
//     final driverDataResponse = driverDataResponseFromJson(jsonString);

import 'dart:convert';

DriverDataResponse driverDataResponseFromJson(String str) => DriverDataResponse.fromJson(json.decode(str));

String driverDataResponseToJson(DriverDataResponse data) => json.encode(data.toJson());

class DriverDataResponse {
    DriverDataResponse({
        this.success,
        this.message,
        this.data,
    });

    bool success;
    dynamic message;
    Data data;

    factory DriverDataResponse.fromJson(Map<String, dynamic> json) => DriverDataResponse(
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
    };
}

class Data {
    Data({
        this.iIdChofer,
        this.vchCorreo,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.fechaNacimiento,
        this.fechaRegistro,
        this.sexo,
        this.telefono,
        this.celular,
        this.urlImage,
    });

    String iIdChofer;
    String vchCorreo;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    DateTime fechaNacimiento;
    DateTime fechaRegistro;
    String sexo;
    String telefono;
    String celular;
    String urlImage;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        iIdChofer: json['iIdChofer'],
        vchCorreo: json['vchCorreo'],
        nombres: json['nombres'],
        apellidoPaterno: json['apellidoPaterno'],
        apellidoMaterno: json['apellidoMaterno'],
        fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
        fechaRegistro: DateTime.parse(json['fechaRegistro']),
        sexo: json['sexo'],
        telefono: json['telefono'],
        celular: json['celular'],
        urlImage: json['urlImage'],
    );

    Map<String, dynamic> toJson() => {
        'iIdChofer': iIdChofer,
        'vchCorreo': vchCorreo,
        'nombres': nombres,
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'fechaNacimiento': '${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}',
        'fechaRegistro': fechaRegistro.toIso8601String(),
        'sexo': sexo,
        'telefono': telefono,
        'celular': celular,
        'urlImage': urlImage,
    };
}

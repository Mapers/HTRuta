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
        this.direccion,
        this.referencia,
        this.saldo,
        this.metodosPago
    });

    String iIdChofer;
    String vchCorreo;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String fechaNacimiento;
    String fechaRegistro;
    String sexo;
    String telefono;
    String celular;
    String urlImage;
    String direccion;
    String referencia;
    double saldo;
    String metodosPago;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        iIdChofer: json['iIdChofer']  ?? '0',
        vchCorreo: json['vchCorreo'] ?? '',
        nombres: json['nombres'] ?? '',
        apellidoPaterno: json['apellidoPaterno'] ?? '',
        apellidoMaterno: json['apellidoMaterno'] ?? '',
        fechaNacimiento: json['fechaNacimiento'] ?? '',
        fechaRegistro: json['fechaRegistro'] ?? '',
        sexo: json['sexo'] ?? '',
        telefono: json['telefono'] ?? '',
        celular: json['celular'] ?? '',
        urlImage: json['urlImage'] ?? '',
        direccion: json['direccion'] ?? '',
        referencia: json['referencia'] ?? '',
        saldo: json['saldo'] != null ? double.parse(json['saldo']) : 0,
        metodosPago: json['metodos_pago'] ?? 'false'
    );

    Map<String, dynamic> toJson() => {
        'iIdChofer': iIdChofer,
        'vchCorreo': vchCorreo,
        'nombres': nombres,
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'fechaNacimiento': fechaNacimiento,
        'fechaRegistro': fechaRegistro,
        'sexo': sexo,
        'telefono': telefono,
        'celular': celular,
        'urlImage': urlImage,
        'direccion': direccion,
        'referencia': referencia
    };
}

// To parse this JSON data, do
//
//     final personDataResponse = personDataResponseFromJson(jsonString);

import 'dart:convert';

PersonDataResponse personDataResponseFromJson(String str) => PersonDataResponse.fromJson(json.decode(str));

String personDataResponseToJson(PersonDataResponse data) => json.encode(data.toJson());

class PersonDataResponse {
    PersonDataResponse({
        this.success,
        this.data,
    });

    bool success;
    Data data;

    factory PersonDataResponse.fromJson(Map<String, dynamic> json) => PersonDataResponse(
        success: json['success'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.toJson(),
    };
}

class Data {
    Data({
        this.numero,
        this.nombreCompleto,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.codigoVerificacion,
    });

    String numero;
    String nombreCompleto;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    int codigoVerificacion;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        numero: json['numero'],
        nombreCompleto: json['nombre_completo'] ?? '',
        nombres: json['nombres'] ?? '',
        apellidoPaterno: json['apellido_paterno'] ?? '',
        apellidoMaterno: json['apellido_materno'] ?? '',
        codigoVerificacion: json['codigo_verificacion'],
    );

    Map<String, dynamic> toJson() => {
        'numero': numero,
        'nombre_completo': nombreCompleto,
        'nombres': nombres,
        'apellido_paterno': apellidoPaterno,
        'apellido_materno': apellidoMaterno,
        'codigo_verificacion': codigoVerificacion,
    };
}

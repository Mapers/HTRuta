// To parse this JSON data, do
//
//     final solicitudUsuarioResponse = solicitudUsuarioResponseFromJson(jsonString);

import 'dart:convert';

import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';

SolicitudUsuarioResponse solicitudUsuarioResponseFromJson(String str) => SolicitudUsuarioResponse.fromJson(json.decode(str));

String solicitudUsuarioResponseToJson(SolicitudUsuarioResponse data) => json.encode(data.toJson());

class SolicitudUsuarioResponse {
    SolicitudUsuarioResponse({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<Request> data;

    factory SolicitudUsuarioResponse.fromJson(Map<String, dynamic> json) => SolicitudUsuarioResponse(
        message: json['message'],
        success: json['success'],
        data: List<Request>.from(json['data'].map((x) => Request.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
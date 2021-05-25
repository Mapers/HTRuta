// To parse this JSON data, do
//
//     final travelAcceptedResponse = travelAcceptedResponseFromJson(jsonString);

import 'dart:convert';

TravelAcceptedResponse travelAcceptedResponseFromJson(String str) => TravelAcceptedResponse.fromJson(json.decode(str));

String travelAcceptedResponseToJson(TravelAcceptedResponse data) => json.encode(data.toJson());

class TravelAcceptedResponse {
    TravelAcceptedResponse({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    Data data;

    factory TravelAcceptedResponse.fromJson(Map<String, dynamic> json) => TravelAcceptedResponse(
        message: json['message'],
        success: json['success'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': data.toJson(),
    };
}

class Data {
    Data({
        this.iIdViaje,
        this.iIdChofer,
        this.iIdUsuario,
        this.iEstado,
        this.vchLatInicial,
        this.vchLatFinal,
        this.vchLongInicial,
        this.vchLongFinal,
        this.mPrecio,
        this.mPropina,
        this.iTipoViaje,
        this.dFecReg,
        this.vchOrigenReferencia,
        this.vchDestinoReferencia,
        this.vchObservacion,
        this.iIdSolicitud,
        this.vchNombreInicial,
        this.vchNombreFinal,
        this.mPrecioCompraViaje,
    });

    String iIdViaje;
    String iIdChofer;
    dynamic iIdUsuario;
    String iEstado;
    String vchLatInicial;
    String vchLatFinal;
    String vchLongInicial;
    String vchLongFinal;
    String mPrecio;
    dynamic mPropina;
    String iTipoViaje;
    DateTime dFecReg;
    dynamic vchOrigenReferencia;
    dynamic vchDestinoReferencia;
    dynamic vchObservacion;
    String iIdSolicitud;
    String vchNombreInicial;
    String vchNombreFinal;
    String mPrecioCompraViaje;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        iIdViaje: json['iIdViaje'],
        iIdChofer: json['iIdChofer'],
        iIdUsuario: json['iIdUsuario'],
        iEstado: json['iEstado'],
        vchLatInicial: json['vchLatInicial'],
        vchLatFinal: json['vchLatFinal'],
        vchLongInicial: json['vchLongInicial'],
        vchLongFinal: json['vchLongFinal'],
        mPrecio: json['mPrecio'],
        mPropina: json['mPropina'],
        iTipoViaje: json['iTipoViaje'],
        dFecReg: DateTime.parse(json['dFecReg']),
        vchOrigenReferencia: json['vchOrigenReferencia'],
        vchDestinoReferencia: json['vchDestinoReferencia'],
        vchObservacion: json['vchObservacion'],
        iIdSolicitud: json['iIdSolicitud'],
        vchNombreInicial: json['vchNombreInicial'],
        vchNombreFinal: json['vchNombreFinal'],
        mPrecioCompraViaje: json['mPrecioCompraViaje'],
    );

    Map<String, dynamic> toJson() => {
        'iIdViaje': iIdViaje,
        'iIdChofer': iIdChofer,
        'iIdUsuario': iIdUsuario,
        'iEstado': iEstado,
        'vchLatInicial': vchLatInicial,
        'vchLatFinal': vchLatFinal,
        'vchLongInicial': vchLongInicial,
        'vchLongFinal': vchLongFinal,
        'mPrecio': mPrecio,
        'mPropina': mPropina,
        'iTipoViaje': iTipoViaje,
        'dFecReg': dFecReg.toIso8601String(),
        'vchOrigenReferencia': vchOrigenReferencia,
        'vchDestinoReferencia': vchDestinoReferencia,
        'vchObservacion': vchObservacion,
        'iIdSolicitud': iIdSolicitud,
        'vchNombreInicial': vchNombreInicial,
        'vchNombreFinal': vchNombreFinal,
        'mPrecioCompraViaje': mPrecioCompraViaje,
    };
}

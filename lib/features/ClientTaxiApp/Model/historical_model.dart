// To parse this JSON data, do
//
//     final historicalModel = historicalModelFromJson(jsonString);

import 'dart:convert';

HistoricalModel historicalModelFromJson(String str) => HistoricalModel.fromJson(json.decode(str));

String historicalModelToJson(HistoricalModel data) => json.encode(data.toJson());

class HistoricalModel {
    HistoricalModel({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<Datum> data;

    factory HistoricalModel.fromJson(Map<String, dynamic> json) => HistoricalModel(
        message: json['message'],
        success: json['success'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.iIdUsuario,
        this.vchCorreo,
        this.dFecReg,
        this.vchDni,
        this.vchNombres,
        this.vchCelular,
        this.mPrecio,
        this.iTipoViaje,
        this.vchLatInicial,
        this.vchLatFinal,
        this.vchLongInicial,
        this.vchLongFinal,
        this.vchNombreInicial,
        this.vchNombreFinal,
        this.comentario,
    });

    String id;
    String iIdUsuario;
    String vchCorreo;
    String dFecReg;
    String vchDni;
    String vchNombres;
    String vchCelular;
    String mPrecio;
    String iTipoViaje;
    String vchLatInicial;
    String vchLatFinal;
    String vchLongInicial;
    String vchLongFinal;
    String vchNombreInicial;
    String vchNombreFinal;
    String comentario;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['Id'],
        iIdUsuario: json['iIdUsuario'],
        vchCorreo: json['vchCorreo'],
        dFecReg: json['dFecReg'],
        vchDni: json['vchDni'],
        vchNombres: json['vchNombres'],
        vchCelular: json['vchCelular'],
        mPrecio: json['mPrecio'],
        iTipoViaje: json['iTipoViaje'],
        vchLatInicial: json['vchLatInicial'],
        vchLatFinal: json['vchLatFinal'],
        vchLongInicial: json['vchLongInicial'],
        vchLongFinal: json['vchLongFinal'],
        vchNombreInicial: json['vchNombreInicial'],
        vchNombreFinal: json['vchNombreFinal'],
        comentario: json['Comentario'],
    );

    Map<String, dynamic> toJson() => {
        'Id': id,
        'iIdUsuario': iIdUsuario,
        'vchCorreo': vchCorreo,
        'dFecReg': dFecReg,
        'vchDni': vchDni,
        'vchNombres': vchNombres,
        'vchCelular': vchCelular,
        'mPrecio': mPrecio,
        'iTipoViaje': iTipoViaje,
        'vchLatInicial': vchLatInicial,
        'vchLatFinal': vchLatFinal,
        'vchLongInicial': vchLongInicial,
        'vchLongFinal': vchLongFinal,
        'vchNombreInicial': vchNombreInicial,
        'vchNombreFinal': vchNombreFinal,
        'Comentario': comentario,
    };
}

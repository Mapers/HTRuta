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
    List<HistoryItem> data;

    factory HistoricalModel.fromJson(Map<String, dynamic> json) => HistoricalModel(
        message: json['message'],
        success: json['success'],
        data: List<HistoryItem>.from(json['data'].map((x) => HistoryItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class HistoryItem {
    HistoryItem({
        this.iIdViaje,
        this.fechaRegistro,
        this.precio,
        this.propina,
        this.comision,
        this.estado,
        this.tipoViaje,
        this.origen,
        this.destino,
        this.distanciaMeters,
    });

    String iIdViaje;
    DateTime fechaRegistro;
    String precio;
    String propina;
    String comision;
    String estado;
    String tipoViaje;
    String origen;
    String destino;
    String distanciaMeters;

    factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        iIdViaje: json['iIdViaje'],
        fechaRegistro: DateTime.parse(json['fecha_registro']),
        precio: json['precio'],
        propina: json['propina'],
        comision: json['comision'],
        estado: json['estado'],
        tipoViaje: json['tipo_viaje'],
        origen: json['origen'],
        destino: json['destino'],
        distanciaMeters: json['distancia_meters'],
    );

    Map<String, dynamic> toJson() => {
        'iIdViaje': iIdViaje,
        'fecha_registro': fechaRegistro.toIso8601String(),
        'precio': precio,
        'propina': propina,
        'comision': comision,
        'estado': estado,
        'tipo_viaje': tipoViaje,
        'origen': origen,
        'destino': destino,
        'distancia_meters': distanciaMeters,
    };
}

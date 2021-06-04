// To parse this JSON data, do
//
//     final historicalDetailResponse = historicalDetailResponseFromJson(jsonString);

import 'dart:convert';

HistoricalDetailResponse historicalDetailResponseFromJson(String str) => HistoricalDetailResponse.fromJson(json.decode(str));

String historicalDetailResponseToJson(HistoricalDetailResponse data) => json.encode(data.toJson());

class HistoricalDetailResponse {
    HistoricalDetailResponse({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<HistoryDetailItem> data;

    factory HistoricalDetailResponse.fromJson(Map<String, dynamic> json) => HistoricalDetailResponse(
        message: json['message'],
        success: json['success'],
        data: List<HistoryDetailItem>.from(json['data'].map((x) => HistoryDetailItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class HistoryDetailItem {
    HistoryDetailItem({
        this.iIdViaje,
        this.fechaRegistro,
        this.precio,
        this.propina,
        this.comision,
        this.estado,
        this.tipoViaje,
        this.origen,
        this.destino,
        this.observacion,
        this.distanciaMeters,
        this.calificacionComentario,
        this.calificacionEstrellas,
        this.calificacionFechaRegistro,
        this.tipoPago,
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
    dynamic observacion;
    String distanciaMeters;
    dynamic calificacionComentario;
    dynamic calificacionEstrellas;
    dynamic calificacionFechaRegistro;
    dynamic tipoPago;

    factory HistoryDetailItem.fromJson(Map<String, dynamic> json) => HistoryDetailItem(
        iIdViaje: json['iIdViaje'],
        fechaRegistro: DateTime.parse(json['fecha_registro']),
        precio: json['precio'],
        propina: json['propina'],
        comision: json['comision'],
        estado: json['estado'],
        tipoViaje: json['tipo_viaje'],
        origen: json['origen'],
        destino: json['destino'],
        observacion: json['observacion'] ?? '',
        distanciaMeters: json['distancia_meters'],
        calificacionComentario: json['calificacion_comentario'],
        calificacionEstrellas: json['calificacion_estrellas'],
        calificacionFechaRegistro: json['calificacion_fechaRegistro'],
        tipoPago: json['tipo_pago'],
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
        'observacion': observacion,
        'distancia_meters': distanciaMeters,
        'calificacion_comentario': calificacionComentario,
        'calificacion_estrellas': calificacionEstrellas,
        'calificacion_fechaRegistro': calificacionFechaRegistro,
        'tipo_pago': tipoPago,
    };
}

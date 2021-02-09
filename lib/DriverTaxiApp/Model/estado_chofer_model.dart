// To parse this JSON data, do
//
//     final estadoChofer = estadoChoferFromJson(jsonString);

import 'dart:convert';

EstadoChofer estadoChoferFromJson(String str) => EstadoChofer.fromJson(json.decode(str));

String estadoChoferToJson(EstadoChofer data) => json.encode(data.toJson());

class EstadoChofer {
    EstadoChofer({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<DataEstadoChofer> data;

    factory EstadoChofer.fromJson(Map<String, dynamic> json) => EstadoChofer(
        message: json["message"],
        success: json["success"],
        data: List<DataEstadoChofer>.from(json["data"].map((x) => DataEstadoChofer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataEstadoChofer {
    DataEstadoChofer({
        this.iEstado,
    });

    String iEstado;

    factory DataEstadoChofer.fromJson(Map<String, dynamic> json) => DataEstadoChofer(
        iEstado: json["iEstado"],
    );

    Map<String, dynamic> toJson() => {
        "iEstado": iEstado,
    };
}

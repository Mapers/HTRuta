import 'dart:convert';

Coordenada coordenadaFromJson(String str) => Coordenada.fromJson(json.decode(str));

String coordenadaToJson(Coordenada data) => json.encode(data.toJson());

class Coordenada {
    Coordenada({
        this.latitud,
        this.longitud,
        this.idConductor,
    });

    double latitud;
    double longitud;
    String idConductor;

    factory Coordenada.fromJson(Map<String, dynamic> json) => Coordenada(
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        idConductor: json["idConductor"],
    );

    Map<String, dynamic> toJson() => {
        "latitud": latitud,
        "longitud": longitud,
        "idConductor": idConductor,
    };
}

import 'dart:convert';

CoordinateModel coordenadaFromJson(String str) => CoordinateModel.fromJson(json.decode(str));

String coordenadaToJson(CoordinateModel data) => json.encode(data.toJson());

class CoordinateModel {
    CoordinateModel({
        this.latitud,
        this.longitud,
        this.idConductor,
    });

    double latitud;
    double longitud;
    String idConductor;

    factory CoordinateModel.fromJson(Map<String, dynamic> json) => CoordinateModel(
        latitud: json['latitud'].toDouble(),
        longitud: json['longitud'].toDouble(),
        idConductor: json['idConductor'],
    );

    Map<String, dynamic> toJson() => {
        'latitud': latitud,
        'longitud': longitud,
        'idConductor': idConductor,
    };
}

import 'dart:convert';

ModeloCarro modeloCarroFromJson(String str) => ModeloCarro.fromJson(json.decode(str));

String modeloCarroToJson(ModeloCarro data) => json.encode(data.toJson());

class ModeloCarro {
    ModeloCarro({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<DataModelo> data;

    factory ModeloCarro.fromJson(Map<String, dynamic> json) => ModeloCarro(
        message: json["message"],
        success: json["success"],
        data: List<DataModelo>.from(json["data"].map((x) => DataModelo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataModelo {
    DataModelo({
        this.iIdModelo,
        this.vchModelo,
    });

    int iIdModelo;
    String vchModelo;

    factory DataModelo.fromJson(Map<String, dynamic> json) => DataModelo(
        iIdModelo: json["iIdModelo"],
        vchModelo: json["vchModelo"],
    );

    Map<String, dynamic> toJson() => {
        "iIdModelo": iIdModelo,
        "vchModelo": vchModelo,
    };
}
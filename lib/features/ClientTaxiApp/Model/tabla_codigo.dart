import 'dart:convert';

TablaCodigo tablaCodigoFromJson(String str) => TablaCodigo.fromJson(json.decode(str));

String tablaCodigoToJson(TablaCodigo data) => json.encode(data.toJson());

class TablaCodigo {
    TablaCodigo({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<Datum> data;

    factory TablaCodigo.fromJson(Map<String, dynamic> json) => TablaCodigo(
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
        this.vchNombreCodigo,
        this.vchValor,
    });

    String vchNombreCodigo;
    int vchValor;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vchNombreCodigo: json['vchNombreCodigo'],
        vchValor: json['vchValor'],
    );

    Map<String, dynamic> toJson() => {
        'vchNombreCodigo': vchNombreCodigo,
        'vchValor': vchValor,
    };
}

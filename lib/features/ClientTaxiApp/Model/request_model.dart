import 'dart:convert';

RequestData requestDataFromJson(String str) => RequestData.fromJson(json.decode(str));

String requestDataToJson(RequestData data) => json.encode(data.toJson());

class RequestData {
    RequestData({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<Solicitud> data;

    factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
        message: json['message'],
        success: json['success'],
        data: List<Solicitud>.from(json['data'].map((x) => Solicitud.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Solicitud {
    Solicitud({
        this.idSolicitud,
    });

    String idSolicitud;

    factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
        idSolicitud: json['IdSolicitud'],
    );

    Map<String, dynamic> toJson() => {
        'IdSolicitud': idSolicitud,
    };
}
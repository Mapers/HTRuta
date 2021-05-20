// To parse this JSON data, do
//
//     final registerTravelBody = registerTravelBodyFromJson(jsonString);

import 'dart:convert';

RegisterTravelBody registerTravelBodyFromJson(String str) => RegisterTravelBody.fromJson(json.decode(str));

String registerTravelBodyToJson(RegisterTravelBody data) => json.encode(data.toJson());

class RegisterTravelBody {
    RegisterTravelBody({
        this.idTokenCliente,
        this.idusuario,
        this.vchLatinicial,
        this.vchLatfinal,
        this.vchLonginicial,
        this.vchLongfinal,
        this.mPrecio,
        this.iTipoViaje,
        this.vchNombreInicial,
        this.vchNombreFinal,
        this.comentario,
        this.unidad,
        this.distancia,
        this.arrFormaPagoIds,
    });

    String idTokenCliente;
    int idusuario;
    double vchLatinicial;
    double vchLatfinal;
    double vchLonginicial;
    double vchLongfinal;
    int mPrecio;
    int iTipoViaje;
    String vchNombreInicial;
    String vchNombreFinal;
    String comentario;
    String unidad;
    int distancia;
    List<int> arrFormaPagoIds;

    factory RegisterTravelBody.fromJson(Map<String, dynamic> json) => RegisterTravelBody(
        idTokenCliente: json['IdTokenCliente'],
        idusuario: json['idusuario'],
        vchLatinicial: json['vchLatinicial'].toDouble(),
        vchLatfinal: json['vchLatfinal'].toDouble(),
        vchLonginicial: json['vchLonginicial'].toDouble(),
        vchLongfinal: json['vchLongfinal'].toDouble(),
        mPrecio: json['mPrecio'],
        iTipoViaje: json['iTipoViaje'],
        vchNombreInicial: json['vchNombreInicial'],
        vchNombreFinal: json['vchNombreFinal'],
        comentario: json['Comentario'],
        unidad: json['unidad'],
        distancia: json['distancia'],
        arrFormaPagoIds: List<int>.from(json['arrFormaPagoIds'].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'IdTokenCliente': idTokenCliente,
        'idusuario': idusuario,
        'vchLatinicial': vchLatinicial,
        'vchLatfinal': vchLatfinal,
        'vchLonginicial': vchLonginicial,
        'vchLongfinal': vchLongfinal,
        'mPrecio': mPrecio,
        'iTipoViaje': iTipoViaje,
        'vchNombreInicial': vchNombreInicial,
        'vchNombreFinal': vchNombreFinal,
        'Comentario': comentario,
        'unidad': unidad,
        'distancia': distancia,
        'arrFormaPagoIds': List<dynamic>.from(arrFormaPagoIds.map((x) => x)),
    };
}

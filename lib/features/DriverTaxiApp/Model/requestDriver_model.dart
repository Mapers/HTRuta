import 'dart:convert';

List<RequestDriverData> requestDriverFromJson(String str) => List<RequestDriverData>.from(json.decode(str).map((x) => RequestDriverData.fromJson(x)));

String requestDriverToJson(List<RequestDriverData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestDriverData {
    RequestDriverData({
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
        this.vchPlaca,
        this.vchModelo,
        this.vchMarca,
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
    String vchPlaca;
    String vchModelo;
    String vchMarca;

    factory RequestDriverData.fromJson(Map<String, dynamic> json) => RequestDriverData(
        iIdUsuario: json["iIdUsuario"],
        vchCorreo: json["vchCorreo"],
        dFecReg: json["dFecReg"],
        vchDni: json["vchDni"],
        vchNombres: json["vchNombres"],
        vchCelular: json["vchCelular"],
        mPrecio: json["mPrecio"],
        iTipoViaje: json["iTipoViaje"],
        vchLatInicial: json["vchLatInicial"],
        vchLatFinal: json["vchLatFinal"],
        vchLongInicial: json["vchLongInicial"],
        vchLongFinal: json["vchLongFinal"],
        vchPlaca: json["vchPlaca"],
        vchModelo: json["vchModelo"],
        vchMarca: json["vchMarca"],
    );

    Map<String, dynamic> toJson() => {
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
        'vchPlaca': vchPlaca,
        'vchModelo': vchModelo,
        'vchMarca': vchMarca,
    };
}
import 'dart:convert';

List<Request> requestFromJson(String str) => List<Request>.from(json.decode(str).map((x) => Request.fromJson(x)));

String requestToJson(List<Request> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
  Request({
      this.id,
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
      this.vchNombreInicial,
      this.vchNombreFinal,
      this.rechazados,
      this.aceptados,
      this.idSolicitud,
      this.comentario,
      this.token
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
  String vchNombreInicial;
  String vchNombreFinal;
  String rechazados;
  String aceptados;
  String idSolicitud;
  String comentario;
  String token;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
      id: json['Id'],
      iIdUsuario: json['iIdUsuario'],
      vchCorreo: json['vchCorreo'],
      dFecReg: json['dFecReg'],
      vchDni: json['vchDni'],
      vchNombres: json['vchNombres'],
      vchCelular: json['vchCelular'],
      mPrecio: json['mPrecio'],
      iTipoViaje: json['iTipoViaje'],
      vchLatInicial: json['vchLatInicial'],
      vchLatFinal: json['vchLatFinal'],
      vchLongInicial: json['vchLongInicial'],
      vchLongFinal: json['vchLongFinal'],
      vchNombreInicial: json['vchNombreInicial'],
      vchNombreFinal: json['vchNombreFinal'],
      rechazados: json['rechazados'],
      aceptados: json['aceptados'],
      idSolicitud: json['IdSolicitud'],
      comentario: json['Comentario'] ?? '',
      token: json['IdTokenCliente'] ?? '',
  );

  Map<String, dynamic> toJson() => {
      'Id': id,
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
      'vchNombreInicial': vchNombreInicial,
      'vchNombreFinal': vchNombreFinal,
      'rechazados': rechazados,
      'aceptados': aceptados,
      'IdSolicitud' : idSolicitud
  };
}


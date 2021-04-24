import 'dart:convert';

PickUpDriverRequest pickUpDriverRequestFromJson(String str) => PickUpDriverRequest.fromJson(json.decode(str));

String pickUpDriverRequestToJson(PickUpDriverRequest data) => json.encode(data.toJson());

class PickUpDriverRequest {
  PickUpDriverRequest({
      this.message,
      this.success,
      this.data,
  });

  String message;
  bool success;
  List<DriverRequest> data;

  factory PickUpDriverRequest.fromJson(Map<String, dynamic> json) => PickUpDriverRequest(
      message: json['message'],
      success: json['success'],
      data: List<DriverRequest>.from(json['data'].map((x) => DriverRequest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
      'message': message,
      'success': success,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DriverRequest {
  DriverRequest({
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
      this.token,
      this.idChofer
  });

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
  String token;
  String idChofer;

  factory DriverRequest.fromJson(Map<String, dynamic> json) => DriverRequest(
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
    vchPlaca: json['vchPlaca'],
    vchModelo: json['vchModelo'],
    vchMarca: json['vchMarca'],
    token: json['IdTokenChofer'],
    idChofer: json['iIdChofer'],
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

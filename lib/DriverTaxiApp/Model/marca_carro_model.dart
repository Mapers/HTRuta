import 'dart:convert';

MarcaCarro marcaCarroFromJson(String str) => MarcaCarro.fromJson(json.decode(str));

String marcaCarroToJson(MarcaCarro data) => json.encode(data.toJson());

class MarcaCarro {
  MarcaCarro({
    this.message,
    this.success,
    this.data,
  });

  String message;
  bool success;
  List<DataMarca> data;

  factory MarcaCarro.fromJson(Map<String, dynamic> json) => MarcaCarro(
    message: json["message"],
    success: json["success"],
    data: List<DataMarca>.from(json["data"].map((x) => DataMarca.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataMarca {
  DataMarca({
    this.iIdMarca,
    this.vchMarca,
  });

  int iIdMarca;
  String vchMarca;

  factory DataMarca.fromJson(Map<String, dynamic> json) => DataMarca(
    iIdMarca: json["iIdMarca"],
    vchMarca: json["vchMarca"],
  );

  Map<String, dynamic> toJson() => {
    "iIdMarca": iIdMarca,
    "vchMarca": vchMarca,
  };
}

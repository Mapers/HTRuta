import 'dart:convert';

Onboarding onboardingFromJson(String str) => Onboarding.fromJson(json.decode(str));

String onboardingToJson(Onboarding data) => json.encode(data.toJson());

class Onboarding {
  Onboarding({
    this.message,
    this.success,
    this.data,
  });

  String message;
  bool success;
  List<Pantallas> data;

  factory Onboarding.fromJson(Map<String, dynamic> json) => Onboarding(
    message: json['message'],
    success: json['success'],
    data: List<Pantallas>.from(json['data'].map((x) => Pantallas.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Pantallas {
  Pantallas({
    this.vchTitulo,
    this.vchRuta,
    this.image64,
  });

  String vchTitulo;
  String vchRuta;
  String image64;

  factory Pantallas.fromJson(Map<String, dynamic> json) => Pantallas(
    vchTitulo: json['vchTitulo'],
    vchRuta: json['vchRuta'],
    image64: json['image_64'],
  );

  Map<String, dynamic> toJson() => {
    'vchTitulo': vchTitulo,
    'vchRuta': vchRuta,
    'image_64': image64,
  };
}

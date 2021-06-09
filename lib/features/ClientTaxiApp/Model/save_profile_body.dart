// To parse this JSON data, do
//
//     final saveProfileBody = saveProfileBodyFromJson(jsonString);

import 'dart:convert';

SaveProfileBody saveProfileBodyFromJson(String str) => SaveProfileBody.fromJson(json.decode(str));

String saveProfileBodyToJson(SaveProfileBody data) => json.encode(data.toJson());

class SaveProfileBody {
    SaveProfileBody({
      this.iIdUsuario,
      this.nombres,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.fechaNacimiento,
      this.sexo,
      this.telefono,
      this.celular,
    });

    String iIdUsuario;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    DateTime fechaNacimiento;
    String sexo;
    String telefono;
    String celular;

    factory SaveProfileBody.fromJson(Map<String, dynamic> json) => SaveProfileBody(
        iIdUsuario: json['iIdUsuario'],
        nombres: json['nombres'],
        apellidoPaterno: json['apellidoPaterno'],
        apellidoMaterno: json['apellidoMaterno'],
        fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
        sexo: json['sexo'],
        telefono: json['telefono'],
        celular: json['celular'],
    );

    Map<String, dynamic> toJson() => {
        'iIdUsuario': iIdUsuario,
        'nombres': nombres,
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'fechaNacimiento': '${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}',
        'sexo': sexo,
        'telefono': telefono,
        'celular': celular,
    };
}

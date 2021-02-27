// To parse this JSON data, do
//
//     final documentoRechazado = documentoRechazadoFromJson(jsonString);

import 'dart:convert';

DocumentoRechazado documentoRechazadoFromJson(String str) => DocumentoRechazado.fromJson(json.decode(str));

String documentoRechazadoToJson(DocumentoRechazado data) => json.encode(data.toJson());

class DocumentoRechazado {
    DocumentoRechazado({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<Documento> data;

    factory DocumentoRechazado.fromJson(Map<String, dynamic> json) => DocumentoRechazado(
        message: json['message'],
        success: json['success'],
        data: List<Documento>.from(json['data'].map((x) => Documento.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Documento {
    Documento({
        this.iIdUsuario,
        this.iIdDocumento,
        this.iTipoDocumento,
        this.nombreDocumento,
        this.vchRuta,
        this.iEstado,
        this.estadoDoc,
    });

    int iIdUsuario;
    int iIdDocumento;
    String iTipoDocumento;
    String nombreDocumento;
    String vchRuta;
    String iEstado;
    String estadoDoc;

    factory Documento.fromJson(Map<String, dynamic> json) => Documento(
        iIdUsuario: json['iIdUsuario'],
        iIdDocumento: json['iIdDocumento'],
        iTipoDocumento: json['iTipoDocumento'],
        nombreDocumento: json['NombreDocumento'],
        vchRuta: json['vchRuta'],
        iEstado: json['iEstado'],
        estadoDoc: json['EstadoDoc'],
    );

    Map<String, dynamic> toJson() => {
        'iIdUsuario': iIdUsuario,
        'iIdDocumento': iIdDocumento,
        'iTipoDocumento': iTipoDocumento,
        'NombreDocumento': nombreDocumento,
        'vchRuta': vchRuta,
        'iEstado': iEstado,
        'EstadoDoc': estadoDoc,
    };
}


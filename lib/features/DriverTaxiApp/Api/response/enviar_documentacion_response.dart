import 'dart:convert';

DocumentoRechazadoResponse documentoRechazadoReponseFromJson(String str) => DocumentoRechazadoResponse.fromJson(json.decode(str));

String documentoRechazadoResponseToJson(DocumentoRechazadoResponse data) => json.encode(data.toJson());

class DocumentoRechazadoResponse {
    DocumentoRechazadoResponse({
        this.documentos,
    });

    List<DocumentoResponse> documentos;

    factory DocumentoRechazadoResponse.fromJson(Map<String, dynamic> json) => DocumentoRechazadoResponse(
        documentos: List<DocumentoResponse>.from(json["documentos"].map((x) => DocumentoResponse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'documentos': List<dynamic>.from(documentos.map((x) => x.toJson())),
    };
}

class DocumentoResponse {
    DocumentoResponse({
        this.base,
        this.iIdDocumento,
        this.iTipoDocumento
    });

    String base;
    int iIdDocumento;
    String iTipoDocumento;

    factory DocumentoResponse.fromJson(Map<String, dynamic> json) => DocumentoResponse(
        base : json["base"],
        iIdDocumento: json["iIdDocumento"],
        iTipoDocumento: json["iTipoDocumento"],
    );

    Map<String, dynamic> toJson() => {
        'base': base,
        'iIdDocumento': iIdDocumento,
        'iTipoDocumento': iTipoDocumento,
    };
}
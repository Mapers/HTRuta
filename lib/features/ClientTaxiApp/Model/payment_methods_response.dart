// To parse this JSON data, do
//
//     final paymentMethodsResponse = paymentMethodsResponseFromJson(jsonString);

import 'dart:convert';

PaymentMethodsResponse paymentMethodsResponseFromJson(String str) => PaymentMethodsResponse.fromJson(json.decode(str));

String paymentMethodsResponseToJson(PaymentMethodsResponse data) => json.encode(data.toJson());

class PaymentMethodsResponse {
    PaymentMethodsResponse({
        this.the0,
        this.the1,
        this.the2,
        this.the3,
        this.the4,
        this.success,
        this.error,
        this.data,
    });

    PaymentMethodClient the0;
    PaymentMethodClient the1;
    PaymentMethodClient the2;
    PaymentMethodClient the3;
    PaymentMethodClient the4;
    bool success;
    dynamic error;
    dynamic data;

    factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) => PaymentMethodsResponse(
        the0: PaymentMethodClient.fromJson(json['0']),
        the1: PaymentMethodClient.fromJson(json['1']),
        the2: PaymentMethodClient.fromJson(json['2']),
        the3: PaymentMethodClient.fromJson(json['3']),
        the4: PaymentMethodClient.fromJson(json['4']),
        success: json['success'],
        error: json['error'],
        data: json['data'],
    );

    Map<String, dynamic> toJson() => {
        '0': the0.toJson(),
        '1': the1.toJson(),
        '2': the2.toJson(),
        '3': the3.toJson(),
        '4': the4.toJson(),
        'success': success,
        'error': error,
        'data': data,
    };
}

class PaymentMethodClient {
    PaymentMethodClient({
        this.iId,
        this.rRuta,
        this.nNombre,
        this.eEstado,
    });

    String iId;
    String rRuta;
    String nNombre;
    String eEstado;

    factory PaymentMethodClient.fromJson(Map<String, dynamic> json) => PaymentMethodClient(
        iId: json['iId'],
        rRuta: json['rRuta'],
        nNombre: json['nNombre'],
        eEstado: json['eEstado'],
    );

    Map<String, dynamic> toJson() => {
        'iId': iId,
        'rRuta': rRuta,
        'nNombre': nNombre,
        'eEstado': eEstado,
    };
}

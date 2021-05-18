// To parse this JSON data, do
//
//     final driverPaymentMethod = driverPaymentMethodFromJson(jsonString);

import 'dart:convert';

DriverPaymentMethod driverPaymentMethodFromJson(String str) => DriverPaymentMethod.fromJson(json.decode(str));

String driverPaymentMethodToJson(DriverPaymentMethod data) => json.encode(data.toJson());

class DriverPaymentMethod {
    DriverPaymentMethod({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<PaymentMethod> data;

    factory DriverPaymentMethod.fromJson(Map<String, dynamic> json) => DriverPaymentMethod(
        message: json['message'],
        success: json['success'],
        data: List<PaymentMethod>.from(json['data'].map((x) => PaymentMethod.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PaymentMethod {
    PaymentMethod({
        this.iId,
        this.rRuta,
        this.nNombre,
        this.eEstado,
        this.df,
        this.selected,
    });

    String iId;
    String rRuta;
    String nNombre;
    String eEstado;
    String df;
    String selected;

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        iId: json['iId'],
        rRuta: json['rRuta'],
        nNombre: json['nNombre'],
        eEstado: json['eEstado'],
        df: json['df'] ,
        selected: json['selected'],
    );

    Map<String, dynamic> toJson() => {
        'iId': iId,
        'rRuta': rRuta,
        'nNombre': nNombre,
        'eEstado': eEstado,
        'df': df,
        'selected': selected,
    };
}

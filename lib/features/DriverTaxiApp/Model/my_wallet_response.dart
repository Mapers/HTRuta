// To parse this JSON data, do
//
//     final myWalletResponse = myWalletResponseFromJson(jsonString);

import 'dart:convert';

MyWalletResponse myWalletResponseFromJson(String str) => MyWalletResponse.fromJson(json.decode(str));

String myWalletResponseToJson(MyWalletResponse data) => json.encode(data.toJson());

class MyWalletResponse {
    MyWalletResponse({
        this.success,
        this.message,
        this.data,
    });

    bool success;
    String message;
    WalletData data;

    factory MyWalletResponse.fromJson(Map<String, dynamic> json) => MyWalletResponse(
        success: json['success'],
        message: json['message'],
        data: WalletData.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
    };
}

class WalletData {
    WalletData({
        this.saldo,
        this.historial,
    });

    double saldo;
    List<Historial> historial;

    factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        saldo: json['saldo'].toDouble(),
        historial: List<Historial>.from(json['historial'].map((x) => Historial.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'saldo': saldo,
        'historial': List<dynamic>.from(historial.map((x) => x.toJson())),
    };
}

class Historial {
    Historial({
        this.iIdChoferBilleteraPago,
        this.iIdChofer,
        this.mMontoRecarga,
    });

    int iIdChoferBilleteraPago;
    String iIdChofer;
    double mMontoRecarga;

    factory Historial.fromJson(Map<String, dynamic> json) => Historial(
        iIdChoferBilleteraPago: json['iIdChoferBilleteraPago'],
        iIdChofer: json['iIdChofer'],
        mMontoRecarga: json['mMontoRecarga'].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        'iIdChoferBilleteraPago': iIdChoferBilleteraPago,
        'iIdChofer': iIdChofer,
        'mMontoRecarga': mMontoRecarga,
    };
}

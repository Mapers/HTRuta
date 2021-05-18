// To parse this JSON data, do
//
//     final saveDriverPmBody = saveDriverPmBodyFromJson(jsonString);

import 'dart:convert';

SaveDriverPmBody saveDriverPmBodyFromJson(String str) => SaveDriverPmBody.fromJson(json.decode(str));

String saveDriverPmBodyToJson(SaveDriverPmBody data) => json.encode(data.toJson());

class SaveDriverPmBody {
    SaveDriverPmBody({
        this.choferId,
        this.arrFormaPagoIds,
    });

    int choferId;
    List<int> arrFormaPagoIds;

    factory SaveDriverPmBody.fromJson(Map<String, dynamic> json) => SaveDriverPmBody(
        choferId: json['choferId'],
        arrFormaPagoIds: List<int>.from(json['arrFormaPagoIds'].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        'choferId': choferId,
        'arrFormaPagoIds': List<dynamic>.from(arrFormaPagoIds.map((x) => x)),
    };
}

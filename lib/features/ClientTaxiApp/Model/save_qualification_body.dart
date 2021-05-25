// To parse this JSON data, do
//
//     final saveQualificationBody = saveQualificationBodyFromJson(jsonString);

import 'dart:convert';

SaveQualificationBody saveQualificationBodyFromJson(String str) => SaveQualificationBody.fromJson(json.decode(str));

String saveQualificationBodyToJson(SaveQualificationBody data) => json.encode(data.toJson());

class SaveQualificationBody {
    SaveQualificationBody({
        this.viajeId,
        this.stars,
        this.comment,
    });

    int viajeId;
    double stars;
    String comment;

    factory SaveQualificationBody.fromJson(Map<String, dynamic> json) => SaveQualificationBody(
        viajeId: json['viajeId'],
        stars: json['stars'].toDouble(),
        comment: json['comment'],
    );

    Map<String, dynamic> toJson() => {
        'viajeId': viajeId,
        'stars': stars,
        'comment': comment,
    };
}

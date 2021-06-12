// To parse this JSON data, do
//
//     final minutesResponse = minutesResponseFromJson(jsonString);

import 'dart:convert';

MinutesResponse minutesResponseFromJson(String str) => MinutesResponse.fromJson(json.decode(str));

String minutesResponseToJson(MinutesResponse data) => json.encode(data.toJson());

class MinutesResponse {
    MinutesResponse({
        this.destinationAddresses,
        this.originAddresses,
        this.rows,
        this.status,
    });

    List<String> destinationAddresses;
    List<String> originAddresses;
    List<AproxRow> rows;
    String status;

    factory MinutesResponse.fromJson(Map<String, dynamic> json) => MinutesResponse(
        destinationAddresses: List<String>.from(json['destination_addresses'].map((x) => x)),
        originAddresses: List<String>.from(json['origin_addresses'].map((x) => x)),
        rows: List<AproxRow>.from(json['rows'].map((x) => AproxRow.fromJson(x))),
        status: json['status'],
    );

    Map<String, dynamic> toJson() => {
        'destination_addresses': List<dynamic>.from(destinationAddresses.map((x) => x)),
        'origin_addresses': List<dynamic>.from(originAddresses.map((x) => x)),
        'rows': List<dynamic>.from(rows.map((x) => x.toJson())),
        'status': status,
    };
}

class AproxRow {
    AproxRow({
        this.elements,
    });

    List<AproxElement> elements;

    factory AproxRow.fromJson(Map<String, dynamic> json) => AproxRow(
        elements: List<AproxElement>.from(json['elements'].map((x) => AproxElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'elements': List<dynamic>.from(elements.map((x) => x.toJson())),
    };
}

class AproxElement {
    AproxElement({
        this.distance,
        this.duration,
        this.status,
    });

    Distance distance;
    Distance duration;
    String status;

    factory AproxElement.fromJson(Map<String, dynamic> json) => AproxElement(
        distance: Distance.fromJson(json['distance']),
        duration: Distance.fromJson(json['duration']),
        status: json['status'],
    );

    Map<String, dynamic> toJson() => {
        'distance': distance.toJson(),
        'duration': duration.toJson(),
        'status': status,
    };
}

class Distance {
    Distance({
        this.text,
        this.value,
    });

    String text;
    int value;

    factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json['text'],
        value: json['value'],
    );

    Map<String, dynamic> toJson() => {
        'text': text,
        'value': value,
    };
}

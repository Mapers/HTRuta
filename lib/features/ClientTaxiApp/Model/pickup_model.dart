// To parse this JSON data, do
//
//     final pickUpRequest = pickUpRequestFromJson(jsonString);

import 'dart:convert';

import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';

PickUpRequest pickUpRequestFromJson(String str) => PickUpRequest.fromJson(json.decode(str));

String pickUpRequestToJson(PickUpRequest data) => json.encode(data.toJson());

class PickUpRequest {
    PickUpRequest({
        this.message,
        this.success,
        this.data,
    });

    String message;
    bool success;
    List<RequestModel> data;

    factory PickUpRequest.fromJson(Map<String, dynamic> json) => PickUpRequest(
        message: json['message'],
        success: json['success'],
        data: List<RequestModel>.from(json['data'].map((x) => RequestModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
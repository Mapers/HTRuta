import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ResponseHttp extends Equatable{
  final bool success;
  final dynamic data;
  final String error;

  ResponseHttp({
    @required this.success,
    @required this.data,
    this.error,
  });

  Map<String, dynamic> get toMap {
    return {
      'data': data,
      'success': success,
      'message': error
    };
  }


  @override
  List<Object> get props => [success, error, data];

  factory ResponseHttp.fromJson(Map<String, dynamic> json) {
    return ResponseHttp(
      data: json['data'],
      success: json['success'],
      error: json['message']
    );
  }

  factory ResponseHttp.error(String error){
    return ResponseHttp(
      data: null,
      success: false,
      error: error
    );
  }
}

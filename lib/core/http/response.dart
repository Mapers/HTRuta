import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ResponseHttp extends Equatable{
  final bool success;
  final dynamic data;
  final String error;

  ResponseHttp({
    @required this.success,
    @required this.data,
    this.error,
  });

  @override
  List<Object> get props => [success, error, data];

  factory ResponseHttp.fromJson(Map<String, dynamic> json) => ResponseHttp(
    data: json['data'],
    success: json['success'],
    error: json['error']
  );

  factory ResponseHttp.error(String error) => ResponseHttp(
    data: null,
    success: false,
    error: error
  );
}
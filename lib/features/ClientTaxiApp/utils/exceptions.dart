import 'package:flutter/foundation.dart';

class ServerException implements Exception {
  final String message;

  ServerException({@required this.message});
}

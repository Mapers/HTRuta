import 'package:meta/meta.dart';

class ServerException implements Exception {
  final String message;

  ServerException({@required this.message});
}

class LocalException implements Exception {
  final String message;

  LocalException({@required this.message});
}

class CacheException implements Exception {}

class PreferencesException implements Exception {
  final String message;

  PreferencesException({@required this.message});
}


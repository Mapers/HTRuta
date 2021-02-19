import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];

  static String getMessage(Failure failure){
    if(failure is ServerFailure){
      return failure.message;
    }else if(failure is CacheFailure){
      return CACHE_FAILURE_MESSAGE;
    }
    return 'Error inesperado :(';
  }
}

// General failures
class ServerFailure extends Failure {
  final String message;
  ServerFailure({@required this.message});
}
class PreferencesFailure extends Failure {
  final String message;
  PreferencesFailure({@required this.message});
}

class CacheFailure extends Failure {}
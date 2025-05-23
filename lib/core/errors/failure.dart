import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
      : assert(
          statusCode is String || statusCode is int,
          "StatusCode can't be ${statusCode.runtimeType}",
        );
  final String message;
  final dynamic statusCode;
  String get errorMessage =>
      '$statusCode ${statusCode is String ? '' : ' Error'}: $message';

  @override
  List<dynamic> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException exception)
      : this(message: exception.message, statusCode: exception.statusCode);
}

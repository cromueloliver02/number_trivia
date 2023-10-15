import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final Object exception;

  const Failure({
    this.message = '',
    this.exception = '',
  });

  @override
  String toString() => 'Failure\nMessage: $message\nException: $exception';

  @override
  List<Object> get props => [message, exception];
}

class ServerFailure extends Failure {
  final int statusCode;

  const ServerFailure({
    required this.statusCode,
    required super.message,
    super.exception,
  });

  @override
  String toString() =>
      'ServerFailure\nStatus code: $statusCode\nMessage: $message\nException: $exception';
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.exception,
  });

  @override
  String toString() => 'CacheFailure\nMessage: $message\nException: $exception';
}

class FormatFailure extends Failure {
  const FormatFailure({
    required super.message,
    super.exception,
  });

  @override
  String toString() =>
      'FormatFailure\nMessage: $message\nException: $exception';
}

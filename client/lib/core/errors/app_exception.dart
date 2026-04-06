sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class NoConnectionException extends NetworkException {
  const NoConnectionException() : super('No internet connection');
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out');
}

class ServerException extends AppException {
  const ServerException({required this.statusCode, required String message})
      : super(message);
  final int statusCode;
}


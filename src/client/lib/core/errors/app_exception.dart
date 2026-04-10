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
  const NoConnectionException() : super('Нет подключения к интернету');
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Превышено время ожидания запроса');
}

class ServerException extends AppException {
  const ServerException({required this.statusCode, required String message})
      : super(message);
  final int statusCode;
}


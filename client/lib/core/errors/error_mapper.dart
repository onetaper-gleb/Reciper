import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exception.dart';

AppException mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException();
    case DioExceptionType.connectionError:
      return const NoConnectionException();
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode ?? 500;
      final msg = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['detail']?.toString() ?? 'Ошибка сервера')
          : 'Ошибка сервера';
      return ServerException(statusCode: statusCode, message: msg);
    case DioExceptionType.cancel:
      return const NetworkException('Запрос отменён');
    case DioExceptionType.unknown:
      if (error.error is SocketException) return const NoConnectionException();
      return NetworkException(error.message ?? 'Неизвестная сетевая ошибка');
    case DioExceptionType.badCertificate:
      return const NetworkException('Проблема с сертификатом');
  }
}


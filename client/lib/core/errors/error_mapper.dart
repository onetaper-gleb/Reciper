import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exception.dart';

String? _parseServerDetail(dynamic data) {
  if (data is! Map) return null;
  final raw = data['detail'];
  if (raw == null) return null;
  if (raw is String) return raw;
  if (raw is List) {
    return raw.map((e) => e.toString()).join(' ');
  }
  return raw.toString();
}

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
      final msg = _parseServerDetail(error.response?.data) ?? 'Ошибка сервера';
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


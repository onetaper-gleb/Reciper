import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'error_mapper.dart';

/// Maps any thrown value from repositories / Dio to a short Russian message for UI.
String userFacingErrorMessage(Object error) {
  if (error is ServerException) {
    return _refineServerMessage(error.message, error);
  }
  if (error is AppException) {
    return _refineServerMessage(error.message, error);
  }
  if (error is DioException) {
    return _refineServerMessage(mapDioError(error).message, error);
  }
  final raw = error.toString();
  if (raw.startsWith('Exception: ')) {
    return _refineServerMessage(raw.substring('Exception: '.length), error);
  }
  return _refineServerMessage(raw, error);
}

String _refineServerMessage(String message, Object error) {
  final lower = message.toLowerCase();
  if (error is ServerException) {
    final code = error.statusCode;
    if (code == 504 || lower.contains('timeout') || lower.contains('timed out')) {
      return 'Сервис не успел ответить. Попробуйте ещё раз или проверьте интернет.';
    }
    if (code == 502 || lower.contains('gemini') || lower.contains('ии')) {
      return 'Сервис ИИ временно недоступен. Попробуйте позже.';
    }
    if (code == 429 || lower.contains('rate') || lower.contains('лимит')) {
      return 'Слишком много запросов. Подождите минуту и попробуйте снова.';
    }
    if (code == 422) {
      return message;
    }
  }
  if (lower.contains('timeout') || lower.contains('timed out')) {
    return 'Превышено время ожидания. Попробуйте ещё раз.';
  }
  if (lower.contains('socket') || lower.contains('network') || lower.contains('connection')) {
    return 'Проблема с сетью. Проверьте подключение.';
  }
  return message;
}

import 'package:dio/dio.dart';

import '../core/errors/error_mapper.dart';
import 'request_signing.dart';

class HttpClientFactory {
  static Dio create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 300),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final signingHeaders = RequestSigning.buildHeaders(
            method: options.method,
            path: options.path,
          );
          options.headers.addAll(signingHeaders);
          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          // Attach mapped domain exception for upper layers.
          final mapped = mapDioError(e);
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: mapped,
            ),
          );
        },
      ),
    );

    return dio;
  }
}


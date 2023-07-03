import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/http/authorization_interceptor.dart';

class DioBuilder {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://giftmanager.skill-branch.ru/api",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
    ),
  );

  DioBuilder() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Dio build() {
    return _dio;
  }

  DioBuilder addAuthorizationInterceptor(final AuthorizationInterceptor interceptor) {
    _dio.interceptors.add(interceptor);
    return this;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioProvider {
  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://giftmanager.skill-branch.ru/api",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
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

    return dio;
  }
}

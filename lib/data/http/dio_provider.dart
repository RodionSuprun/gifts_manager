import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioProvider {
  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://giftmanager.skill-branch.ru/api",
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

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/login_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';

import 'model/create_account_request_dto.dart';
import 'model/gifts_response_dto.dart';
import 'model/reset_password_request_dto.dart';

class BaseApiService {

  Future<Either<ApiError, T>> responseOrError<T>(
    AsyncValueGetter<T> request,
  ) async {
    try {
      final response = await request();
      return Right(response);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  ApiError _getApiError(final dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse && e.response != null) {
        try {
          return ApiError.fromJson(e.response!.data);
        } catch (apiExp) {
          return const ApiError(code: ApiErrorType.unknown);
        }
      }
    }
    return const ApiError(code: ApiErrorType.unknown);
  }
}

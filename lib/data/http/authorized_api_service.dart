import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/login_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';

import 'base_api_service.dart';
import 'model/create_account_request_dto.dart';
import 'model/gifts_response_dto.dart';
import 'model/reset_password_request_dto.dart';

class AuthorizedApiService extends BaseApiService {
  final Dio _dio;

  AuthorizedApiService(this._dio);

  Future<Either<ApiError, GiftsResponseDto>> getAllGifts({
    final int limit = 10,
    final int offset = 0,
  }) async {
    return responseOrError(() async {
      final response = await _dio.get(
        "/user/gifts",
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        // options: Options(
        //   headers: {
        //     HttpHeaders.authorizationHeader: "Bearer $token",
        //   },
        // ),
      );

      print(response.data);

      return GiftsResponseDto.fromJson(response.data);
    });
  }
}

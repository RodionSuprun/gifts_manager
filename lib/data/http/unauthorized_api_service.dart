import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/login_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';

import 'base_api_service.dart';
import 'model/create_account_request_dto.dart';
import 'model/gifts_response_dto.dart';
import 'model/reset_password_request_dto.dart';

class UnauthorizedApiService extends BaseApiService {
  final Dio _dio;

  UnauthorizedApiService(this._dio);

  Future<Either<ApiError, UserWithTokenDTO>> register({
    required final String email,
    required final String password,
    required final String name,
    required final String avatarUrl,
  }) async {
    final requestBody = CreateAccountRequestDTO(
      email: email,
      name: name,
      password: password,
      avatarUrl: avatarUrl,
    );
    return responseOrError(() async {
      final response = await _dio.post(
        "/auth/create",
        data: requestBody.toJson(),
      );

      final userWithTokens = UserWithTokenDTO.fromJson(response.data);
      return userWithTokens;
    });
  }

  Future<Either<ApiError, UserWithTokenDTO>> login({
    required final String email,
    required final String password,
  }) async {
    final requestBody = LoginRequestDTO(
      email: email,
      password: password,
    );
    return responseOrError(() async {
      final response = await _dio.post(
        "/auth/login",
        data: requestBody.toJson(),
      );

      final userWithTokens = UserWithTokenDTO.fromJson(response.data);
      return userWithTokens;
    });
  }

  Future<Either<ApiError, UserWithTokenDTO>> resetPassword(
      {required final String email}) async {
    final requestBody = ResetPasswordRequestDTO(
      email: email,
    );

    return responseOrError(() async {
      final response = await _dio.post(
        "/auth/reset-password",
        data: requestBody.toJson(),
      );

      final userWithTokens = UserWithTokenDTO.fromJson(response.data);
      return userWithTokens;
    });
  }
}

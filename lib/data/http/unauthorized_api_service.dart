import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/login_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';

import 'model/create_account_request_dto.dart';

class UnauthorizedApiService {
  static UnauthorizedApiService? _instance;

  factory UnauthorizedApiService.getInstance() =>
      _instance ??= UnauthorizedApiService._internal();

  UnauthorizedApiService._internal();

  final Dio _dio = DioProvider().createDio();

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

    try {
      final response = await _dio.post(
        "/auth/create",
        data: requestBody.toJson(),
      );

      final userWithTokens = UserWithTokenDTO.fromJson(response.data);

      return Right(userWithTokens);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  Future<Either<ApiError, UserWithTokenDTO>> login({
    required final String email,
    required final String password,
  }) async {
    final requestBody = LoginRequestDTO(
      email: email,
      password: password,
    );

    try {
      final response = await _dio.post(
        "/auth/login",
        data: requestBody.toJson(),
      );

      final userWithTokens = UserWithTokenDTO.fromJson(response.data);
      return Right(userWithTokens);
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

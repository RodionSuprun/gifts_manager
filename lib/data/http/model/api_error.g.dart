// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
      code: json['code'],
      error: json['error'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
      'code': instance.code,
      'error': instance.error,
      'message': instance.message,
    };
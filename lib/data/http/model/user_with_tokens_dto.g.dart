// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_with_tokens_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWithTokenDTO _$UserWithTokenDTOFromJson(Map<String, dynamic> json) =>
    UserWithTokenDTO(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$UserWithTokenDTOToJson(UserWithTokenDTO instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

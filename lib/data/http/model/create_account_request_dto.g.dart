// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_account_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAccountRequestDTO _$CreateAccountRequestDTOFromJson(
        Map<String, dynamic> json) =>
    CreateAccountRequestDTO(
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$CreateAccountRequestDTOToJson(
        CreateAccountRequestDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'avatarUrl': instance.avatarUrl,
    };

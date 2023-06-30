import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError extends Equatable {
  final dynamic code;
  final String? error;
  final String? message;

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);

  const ApiError({required this.code, this.error, this.message});

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  ApiErrorType get errorType => ApiErrorType.getByCode(code);

  @override
  List<Object?> get props => [code, error, message];
}

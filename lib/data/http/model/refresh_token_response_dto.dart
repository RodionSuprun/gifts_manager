import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_dto.g.dart';

@JsonSerializable()
class RefreshTokenResponseDto extends Equatable {
  final String token;
  final String refreshToken;

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseDtoFromJson(json);

  const RefreshTokenResponseDto({
    required this.token,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => _$RefreshTokenResponseDtoToJson(this);

  @override
  List<Object?> get props => [];
}

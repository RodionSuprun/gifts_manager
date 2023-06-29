import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_with_tokens_dto.g.dart';

@JsonSerializable()
class UserWithTokenDTO extends Equatable {
  final String token;
  final String refreshToken;
  final UserDto user;

  const UserWithTokenDTO({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory UserWithTokenDTO.fromJson(Map<String, dynamic> json) =>
      _$UserWithTokenDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserWithTokenDTOToJson(this);

  @override
  List<Object?> get props => [token, refreshToken, user];
}

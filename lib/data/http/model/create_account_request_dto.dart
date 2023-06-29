import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_request_dto.g.dart';

@JsonSerializable()
class CreateAccountRequestDTO extends Equatable {
  final String email;
  final String name;
  final String password;
  final String avatarUrl;

  const CreateAccountRequestDTO({
    required this.email,
    required this.name,
    required this.password,
    required this.avatarUrl,
  });

  factory CreateAccountRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAccountRequestDTOToJson(this);

  @override
  List<Object?> get props => [email, name, password, avatarUrl];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable()
class ResetPasswordRequestDTO extends Equatable {

  final String email;

  const ResetPasswordRequestDTO({
    required this.email,
  });

  factory ResetPasswordRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDTOToJson(this);

  @override
  List<Object?> get props => [];
}

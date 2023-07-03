import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/model/gift_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gifts_response_dto.g.dart';

@JsonSerializable()
class GiftsResponseDto extends Equatable {

  final List<GiftDTO> gifts;

  factory GiftsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GiftsResponseDtoFromJson(json);

  const GiftsResponseDto({required this.gifts});

  Map<String, dynamic> toJson() => _$GiftsResponseDtoToJson(this);

  @override
  List<Object?> get props => [gifts];
}

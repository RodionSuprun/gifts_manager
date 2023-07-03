import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gift_dto.g.dart';

@JsonSerializable()
class GiftDTO extends Equatable {
  final String id;
  final String name;
  final double? price;
  final String? link;

  factory GiftDTO.fromJson(Map<String, dynamic> json) =>
      _$GiftDTOFromJson(json);

  const GiftDTO({
    required this.id,
    required this.name,
    this.price,
    this.link,
  });

  Map<String, dynamic> toJson() => _$GiftDTOToJson(this);

  @override
  List<Object?> get props => [id, name, price, link];
}

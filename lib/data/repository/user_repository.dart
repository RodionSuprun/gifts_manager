import 'dart:convert';

import 'package:gifts_manager/data/http/model/user_dto.dart';

import '../../di/service_locator.dart';
import '../storage/shared_preference_data.dart';
import 'base/reactive_repository.dart';

class UserRepository extends ReactiveRepository<UserDto> {
  static UserRepository? _instance;

  factory UserRepository.getInstance() => _instance ??=
      UserRepository._internal(sl.get<SharedPreferenceData>());

  UserRepository._internal(this._spData);

  final SharedPreferenceData _spData;

  @override
  UserDto convertFromString(String rawItem) =>
      UserDto.fromJson(json.decode(rawItem));

  @override
  String convertToString(UserDto item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _spData.getUser();

  @override
  Future<bool> saveRawData(String? item) => _spData.setUser(item);
}
import 'dart:convert';

import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/user_provider.dart';

import '../../di/service_locator.dart';
import '../storage/shared_preference_data.dart';
import 'base/reactive_repository.dart';

class UserRepository extends ReactiveRepository<UserDto> {

  UserRepository(this._userProvider);

  final UserProvider _userProvider;

  @override
  UserDto convertFromString(String rawItem) =>
      UserDto.fromJson(json.decode(rawItem));

  @override
  String convertToString(UserDto item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _userProvider.getUser();

  @override
  Future<bool> saveRawData(String? item) => _userProvider.setUser(item);
}
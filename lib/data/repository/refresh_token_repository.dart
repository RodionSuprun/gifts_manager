

import '../storage/shared_preference_data.dart';
import 'base/reactive_repository.dart';

class RefreshTokenRepository extends ReactiveRepository<String> {
  static RefreshTokenRepository? _instance;

  factory RefreshTokenRepository.getInstance() => _instance ??=
      RefreshTokenRepository._internal(SharedPreferenceData.getInstance());

  RefreshTokenRepository._internal(this._spData);

  final SharedPreferenceData _spData;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _spData.getRefreshToken();

  @override
  Future<bool> saveRawData(String? item) => _spData.setRefreshToken(item);
}
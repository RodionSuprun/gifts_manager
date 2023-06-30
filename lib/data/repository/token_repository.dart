import '../storage/shared_preference_data.dart';
import 'base/reactive_repository.dart';

class TokenRepository extends ReactiveRepository<String> {
  static TokenRepository? _instance;

  factory TokenRepository.getInstance() => _instance ??=
      TokenRepository._internal(SharedPreferenceData.getInstance());

  TokenRepository._internal(this._spData);

  final SharedPreferenceData _spData;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _spData.getToken();

  @override
  Future<bool> saveRawData(String? item) => _spData.setToken(item);
}
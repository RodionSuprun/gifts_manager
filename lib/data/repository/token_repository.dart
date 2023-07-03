import 'package:gifts_manager/data/repository/token_provider.dart';

import '../../di/service_locator.dart';
import '../storage/shared_preference_data.dart';
import 'base/reactive_repository.dart';

class TokenRepository extends ReactiveRepository<String> {
  TokenRepository(this._tokenProvider);

  final TokenProvider _tokenProvider;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _tokenProvider.getToken();

  @override
  Future<bool> saveRawData(String? item) => _tokenProvider.setToken(item);
}

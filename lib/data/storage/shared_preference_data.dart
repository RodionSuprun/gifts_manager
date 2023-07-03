import 'package:shared_preferences/shared_preferences.dart';

import '../repository/refresh_token_provider.dart';

class SharedPreferenceData implements RefreshTokenProvider {
  static const _tokenKey = "token_key";
  static const _userKey = "user_key";
  static const _refreshTokenKey = "refresh_token_key";

  Future<bool> setToken(final String? token) =>
      _setItem(key: _tokenKey, item: token);

  Future<String?> getToken() => _getItem(_tokenKey);

  Future<bool> setUser(final String? user) =>
      _setItem(key: _userKey, item: user);

  Future<String?> getUser() => _getItem(_userKey);

  @override
  Future<bool> setRefreshToken(final String? refreshTokenKey) =>
      _setItem(key: _refreshTokenKey, item: refreshTokenKey);

  @override
  Future<String?> getRefreshToken() => _getItem(_refreshTokenKey);

  Future<bool> _setItem({
    required final String key,
    required final String? item,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? '');
    return result;
  }

  Future<String?> _getItem(
    final String key,
  ) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}

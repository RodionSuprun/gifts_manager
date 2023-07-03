abstract class RefreshTokenProvider {
  Future<bool> setRefreshToken(final String? refreshTokenKey);

  Future<String?> getRefreshToken();
}
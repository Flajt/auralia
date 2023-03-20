abstract class OauthKeyServiceA {
  Future<void> putAccessTokens(String providerToken, String refreshToken);
  Future<String?> get accessToken;
  Future<String?> get refreshToken;
  Future<void> updateAccessToken(String jwt);
}

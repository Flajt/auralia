import 'package:auralia/logic/services/SecureStorageWrapperService.dart';
import 'package:http/http.dart' as http;

class SpotifyOauthKeyService {
  final SecureStorageWrapperService _storageWrapperService;
  final String jwt;
  SpotifyOauthKeyService(
      SecureStorageWrapperService secureStorageWrapperService, this.jwt)
      : _storageWrapperService = secureStorageWrapperService;

  putAccessTokens(String providerToken, String refreshToken) async {
    await _storageWrapperService.write("refreshToken", refreshToken);
    await _storageWrapperService.write("providerToken", providerToken);
  }

  Future<String?> get accessToken async =>
      await _storageWrapperService.read("providerToken");
  Future<String?> get refreshToken async =>
      _storageWrapperService.read("refreshToken");
  updateAccessToken() async {
    String? refToken = await refreshToken;
    http.get(Uri.parse("localhost:8000/update-tokens"),
        headers: {"Authorization": "Bearer $jwt", "X-RefreshToken": refToken!});
  }
}

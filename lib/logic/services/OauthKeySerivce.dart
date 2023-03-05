import 'dart:convert';
import 'package:auralia/logic/services/SecureStorageWrapperService.dart';
import 'package:http/http.dart' as http;

class SpotifyOauthKeyService {
  late final SecureStorageWrapperService _storageWrapperService;
  late final String _jwt;
  final String baseUrl;
  SpotifyOauthKeyService(
      {required String jwt,
      required SecureStorageWrapperService storageWrapperService,
      this.baseUrl = "http://192.168.0.6:8000"}) {
    _jwt = jwt;
    _storageWrapperService = storageWrapperService;
  }

  Future<void> putAccessTokens(
      String providerToken, String refreshToken) async {
    await _storageWrapperService.write("refreshToken", refreshToken);
    await _storageWrapperService.write("providerToken", providerToken);
  }

  Future<String?> get accessToken async =>
      await _storageWrapperService.read("providerToken");
  Future<String?> get refreshToken async =>
      _storageWrapperService.read("refreshToken");

  Future<void> updateAccessToken() async {
    String? refToken = await refreshToken;
    http.Response resp = await http.get(Uri.parse("$baseUrl/update-token"),
        headers: {
          "Authorization": "Bearer $_jwt",
          "X-Refresh-Token": refToken!
        });

    if (resp.statusCode < 401) {
      final accessToken = jsonDecode(resp.body)["access_token"];
      await putAccessTokens(accessToken, refToken);
    } else {
      throw "Can't update Spotify Token!";
    }
  }
}

import 'dart:convert';
import 'package:auralia/logic/abstract/SecureStorageServiceA.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../abstract/OauthKeyServiceA.dart';

class SpotifyOauthKeyService implements OauthKeyServiceA {
  late final SecureStorageServiceA _storageWrapperService;
  final String baseUrl;
  final _getIt = GetIt.I;
  SpotifyOauthKeyService({this.baseUrl = "http://192.168.0.6:8000"}) {
    _storageWrapperService = _getIt<SecureStorageServiceA>();
  }

  @override
  Future<void> putAccessTokens(
      String providerToken, String refreshToken) async {
    await _storageWrapperService.write("refreshToken", refreshToken);
    await _storageWrapperService.write("providerToken", providerToken);
  }

  @override
  Future<String?> get accessToken async =>
      await _storageWrapperService.read("providerToken");
  @override
  Future<String?> get refreshToken async =>
      _storageWrapperService.read("refreshToken");

  @override
  Future<void> updateAccessToken(String jwt) async {
    String? refToken = await refreshToken;
    http.Response resp = await http.get(Uri.parse("$baseUrl/update-token"),
        headers: {
          "Authorization": "Bearer $jwt",
          "X-Refresh-Token": refToken!
        });
    if (resp.statusCode < 400) {
      final accessToken = jsonDecode(resp.body)["access_token"];
      await putAccessTokens(accessToken, refToken);
    } else {
      throw "Can't update Spotify Token!";
    }
  }
}

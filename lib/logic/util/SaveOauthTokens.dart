import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/OauthKeySerivce.dart';
import '../services/SecureStorageWrapperService.dart';

void saveOauthTokens(AsyncSnapshot<AuthState> snapshot) {
  String jwt = snapshot.data!.session!.accessToken;
  String? refreshToken = snapshot.data!.session!.providerRefreshToken;
  if (refreshToken != null) {
    String providerToken = snapshot.data!.session!.providerToken!;
    SpotifyOauthKeyService(
            jwt: jwt, storageWrapperService: SecureStorageWrapperService())
        .putAccessTokens(providerToken, refreshToken);
  }
}

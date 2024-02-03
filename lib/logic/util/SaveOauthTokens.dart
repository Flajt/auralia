import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/OauthKeySerivce.dart';

void saveOauthTokens(AsyncSnapshot<AuthState> snapshot) {
  String? refreshToken = snapshot.data!.session!.providerRefreshToken;
  if (refreshToken != null) {
    String providerToken = snapshot.data!.session!.providerToken!;
    SpotifyOauthKeyService().putAccessTokens(providerToken, refreshToken);
  }
}

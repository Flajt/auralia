import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService implements AuthServiceA {
  @override
  Future<String> get accessToken async =>
      Supabase.instance.client.auth.currentSession!.accessToken;

  @override
  Future<void> deleteAccount() {
    throw UnimplementedError();
  }

  @override
  Future<String> getSignInUrl() async {
    OAuthResponse oauthResp = await Supabase.instance.client.auth.getOAuthSignInUrl(
        provider: Provider.spotify,
        redirectTo: "background://auralia",
        scopes:
            "user-read-email user-read-private user-read-recently-played app-remote-control user-read-playback-state");
    return oauthResp.url!;
  }

  @override
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Future<void> init() async {
    try {
      await Supabase.initialize(
          url: "https://limbadcemvavrnorbkig.supabase.co",
          anonKey:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpbWJhZGNlbXZhdnJub3Jia2lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzY5ODYzNTYsImV4cCI6MTk5MjU2MjM1Nn0.RgD8isCOgvIADI9Yv9iifhFi1grpwzZYP-BGIeXXzJM");
    } catch (e, stack) {
      Supabase.instance;
    }
  }
}

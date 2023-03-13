import 'package:auralia/logic/webview/SpotifyChoreSafariBrowser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:line_icons/line_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SpotifyButton extends StatelessWidget {
  const SpotifyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SpotifyChromeSafariBrowser browser = SpotifyChromeSafariBrowser();
    return ElevatedButton.icon(
      onPressed: () async {
        OAuthResponse oauthResp = await Supabase.instance.client.auth
            .getOAuthSignInUrl(
                provider: Provider.spotify,
                redirectTo: "background://auralia",
                scopes:
                    "user-read-email user-read-private user-read-recently-played app-remote-control user-read-playback-state");
        String url = oauthResp.url!;
        browser.open(
            url: Uri.parse(url),
            options: ChromeSafariBrowserClassOptions(
                android: AndroidChromeCustomTabsOptions(
              shareState: CustomTabsShareState.SHARE_STATE_OFF,
              isSingleInstance: true,
            )));
      },
      icon: const Icon(LineIcons.spotify, size: 35),
      label: const Text("Sign In With Spotify"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff1db954),
        elevation: 3,
        textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        foregroundColor: Colors.black,
        shadowColor: Colors.grey,
      ),
    );
  }
}

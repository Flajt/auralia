import 'dart:io';

import 'package:auralia/logic/services/OauthKeySerivce.dart';

Future<void> iOSTokenRefresh(SpotifyOauthKeyService keyService) async {
  if (Platform.isIOS) {
    await keyService.updateAccessToken();
  }
}

import 'dart:io';

import 'package:auralia/logic/services/OauthKeySerivce.dart';

Future<void> tokenRefresh(SpotifyOauthKeyService keyService) async {
  await keyService.updateAccessToken();
}

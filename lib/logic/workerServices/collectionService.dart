import 'package:auralia/logic/services/OauthKeySerivce.dart';
import 'package:auralia/logic/services/SecureStorageWrapperService.dart';
import 'package:auralia/logic/util/initSuperbase.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void updateOauthAccessToken() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final supabase = await initSupabase();
      String jwt = supabase.client.auth.currentSession!.accessToken;
      final oauthService = SpotifyOauthKeyService(
          jwt: jwt, storageWrapperService: SecureStorageWrapperService());
      await oauthService.updateAccessToken();
      bool hasAServiceRunning = await FlutterForegroundTask.isRunningService;
      if (hasAServiceRunning) {
        await FlutterForegroundTask.restartService();
      }
      return Future.value(true);
    } catch (e) {
      Logger().e(e.toString());
      return Future.error(e);
    }
  });
}

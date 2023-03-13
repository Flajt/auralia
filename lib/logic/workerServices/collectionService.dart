import 'package:auralia/logic/services/OauthKeySerivce.dart';
import 'package:auralia/logic/services/SecureStorageWrapperService.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/util/initSuperbase.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void updateOauthAccessToken() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await initSentry();
      bool hasNet = await InternetUtil.hasInternet();

      final supabase = await initSupabase();
      String jwt = supabase.client.auth.currentSession!.accessToken;
      final oauthService = SpotifyOauthKeyService(
          jwt: jwt,
          storageWrapperService: SecureStorageWrapperService(),
          baseUrl: "https://auralia.fly.dev");
      await oauthService.updateAccessToken();
      bool hasAServiceRunning = await FlutterForegroundTask.isRunningService;
      if (hasAServiceRunning) {
        await FlutterForegroundTask.restartService();
      }
      await Sentry.addBreadcrumb(Breadcrumb(
          message: "collectionService before initSupabase",
          data: {
            "hasInternet": hasNet,
            "foregroundService": hasAServiceRunning
          },
          level: SentryLevel.info));
      return Future.value(true);
    } catch (e, stack) {
      await Sentry.captureException(e, stackTrace: stack);
      return Future.error(e);
    }
  });
}

import 'package:auralia/logic/abstract/CollectionForegroundServiceA.dart';
import 'package:auralia/logic/services/AuthService.dart';
import 'package:auralia/logic/services/ForegroundServices/CollectionForegroundService.dart';
import 'package:auralia/logic/services/OauthKeySerivce.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/util/registerServices.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../abstract/AuthServiceA.dart';

@pragma('vm:entry-point')
void updateOauthAccessToken() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await initSentry();
      await registerServices();
      final getIt = GetIt.I;
      bool hasNet = await InternetUtil.hasInternet();
      final authService = getIt<AuthServiceA>();
      await authService.init();
      await authService.refreshAccessToken();

      bool hasAServiceRunning =
          await getIt<CollectionForegroundServiceA>().isServiceRunning();
      if (hasAServiceRunning) {
        await getIt<CollectionForegroundServiceA>().restartService();
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

import 'package:auralia/logic/abstract/CollectionForegroundServiceA.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/util/registerServices.dart';
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
      CollectionForegroundServiceA foregroundService =
          getIt<CollectionForegroundServiceA>();
      final authService = getIt<AuthServiceA>();
      await authService.init();
      await authService.refreshAccessToken();

      bool hasAServiceRunning = await foregroundService.isServiceRunning();
      if (hasAServiceRunning) {
        await foregroundService.restartService();
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

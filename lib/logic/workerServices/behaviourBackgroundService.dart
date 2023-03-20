import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/services/BehaviourUploadService.dart';
import 'package:auralia/logic/services/DBService.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/util/registerServices.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
Future<void> behaviourBackgroundService() async {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await registerServices();
      final hasNet = await InternetUtil.hasInternet();
      final GetIt getIt = GetIt.I;
      getIt.registerSingleton<DBServiceA>(IsarDBService());
      await initSentry();
      await Sentry.addBreadcrumb(Breadcrumb(
          message: "behaviourBackgroundService before upload",
          data: {"hasInternet": hasNet},
          level: SentryLevel.info));
      final uploadService = BehaviourUploadService(
          getIt: getIt, baseUrl: "https://auralia.fly.dev");
      await uploadService.uploadSongs();
      return Future.value(true);
    } catch (e, stack) {
      await Sentry.captureException(e, stackTrace: stack);
      return Future.error(e);
    }
  });
}

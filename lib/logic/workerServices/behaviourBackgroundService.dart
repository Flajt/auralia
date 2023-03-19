import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/services/BehaviourUploadService.dart';
import 'package:auralia/logic/services/DBService.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/util/initSuperbase.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
Future<void> behaviourBackgroundService() async {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final hasNet = await InternetUtil.hasInternet();
      final GetIt getIt = GetIt.I;
      getIt.registerSingleton<DBServiceA>(IsarDBService());
      await initSentry();
      await Sentry.addBreadcrumb(Breadcrumb(
          message: "behaviourBackgroundService before initSupabase",
          data: {"hasInternet": hasNet},
          level: SentryLevel.info));
      final supabase = await initSupabase();
      final accessToken = supabase.client.auth.currentSession!.accessToken;
      final uploadService = BehaviourUploadService(
          getIt: getIt, jwt: accessToken, baseUrl: "https://auralia.fly.dev");
      await uploadService.uploadSongs();
      return Future.value(true);
    } catch (e, stack) {
      await Sentry.captureException(e, stackTrace: stack);
      return Future.error(e);
    }
  });
}

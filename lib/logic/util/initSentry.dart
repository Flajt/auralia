import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> initSentry(VoidCallback? runApp) async {
  await SentryFlutter.init((p0) {
    p0.dsn = kDebugMode
        ? ""
        : "https://b2410170c0db436ea1eac986dc20ff22@o517360.ingest.sentry.io/4504797082288128";
    p0.tracesSampleRate = .5;
  }, appRunner: runApp ?? runApp);
}

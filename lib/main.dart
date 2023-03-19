import 'dart:io';

import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/services/AuthService.dart';
import 'package:auralia/logic/services/DBService.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/webview/SpotifyChoreSafariBrowser.dart';
import 'package:auralia/logic/workerServices/behaviourBackgroundService.dart';
import 'package:auralia/pages/HomePage.dart';
import 'package:auralia/pages/LoginPage.dart';
import 'package:auralia/pages/UserBehaviourPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'logic/util/SaveOauthTokens.dart';
import 'logic/util/initSuperbase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GetIt getIt = GetIt.I;
  getIt.registerSingleton<AuthServiceA>(AuthService());
  await getIt<AuthServiceA>().init();
  getIt
      .registerFactory<ChromeSafariBrowser>(() => SpotifyChromeSafariBrowser());
  getIt.registerLazySingleton<DBServiceA>(() => IsarDBService());
  if (Platform.isAndroid) {
    await Workmanager()
        .initialize(behaviourBackgroundService, isInDebugMode: true);
    await Workmanager().registerPeriodicTask(
        "auralia_upload_service", "Uploads data to backend",
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(hours: 24),
        initialDelay: const Duration(minutes: 5),
        backoffPolicy: BackoffPolicy.exponential);
  }
  await initSupabase();
  await initSentry(() => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [SentryNavigatorObserver()],
      title: 'Auralia',
      routes: {"/listeningBehaviour": (context) => const UserBehaviourPage()},
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff11FfEE), useMaterial3: true),
      home: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot) {
          if (snapshot.hasData &&
                  snapshot.data?.event == AuthChangeEvent.signedIn ||
              snapshot.data?.event == AuthChangeEvent.tokenRefreshed) {
            if (snapshot.data?.event == AuthChangeEvent.signedIn) {
              saveOauthTokens(snapshot);
            }
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/workerServices/behaviourBackgroundService.dart';
import 'package:auralia/pages/HomePage.dart';
import 'package:auralia/pages/LoginPage.dart';
import 'package:auralia/pages/UserBehaviourPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'bloc/UserBehaviourBloc/UserBehaviourBloc.dart';
import 'logic/util/SaveOauthTokens.dart';
import 'logic/util/registerServices.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///TODO: Refactor into setup function
  await registerServices();
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
  await initSentry(() => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [SentryNavigatorObserver()],
      title: 'Auralia',
      routes: {
        "/listeningBehaviour": (context) => BlocProvider(
              create: (context) => UserBehaviourBloc(),
              child: const UserBehaviourPage(),
            )
      },
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

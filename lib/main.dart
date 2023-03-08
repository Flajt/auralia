import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/workerServices/behaviourBackgroundService.dart';
import 'package:auralia/logic/workerServices/collectionService.dart';
import 'package:auralia/pages/HomePage.dart';
import 'package:auralia/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'logic/util/SaveOauthTokens.dart';
import 'logic/util/initSuperbase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(updateOauthAccessToken, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
      "auralia_oauth_update_service", "Updates Spotify Access Token",
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: const Duration(minutes: 5),
      frequency: const Duration(minutes: 50));
  Workmanager().initialize(behaviourBackgroundService, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
      "auralia_upload_service", "Uploads data to backend",
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: const Duration(hours: 24),
      initialDelay: const Duration(minutes: 5),
      backoffPolicy: BackoffPolicy.exponential);

  await initSupabase();
  await initSentry(() => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auralia',
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

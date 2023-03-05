import 'package:auralia/pages/HomePage.dart';
import 'package:auralia/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'logic/util/SaveOauthTokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /**Workmanager()
      .initialize(locationActivityCollectionService, isInDebugMode: true);
  Workmanager().registerPeriodicTask("1", "Data collection",
      frequency: const Duration(minutes: 2));*/

  await Supabase.initialize(
      url: "https://limbadcemvavrnorbkig.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpbWJhZGNlbXZhdnJub3Jia2lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzY5ODYzNTYsImV4cCI6MTk5MjU2MjM1Nn0.RgD8isCOgvIADI9Yv9iifhFi1grpwzZYP-BGIeXXzJM");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

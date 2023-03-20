import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';

import '../abstract/AuthServiceA.dart';
import '../abstract/CollectionForegroundServiceA.dart';
import '../abstract/DBServiceA.dart';
import '../abstract/OauthKeyServiceA.dart';
import '../abstract/SecureStorageServiceA.dart';
import '../services/AuthService.dart';
import '../services/DBService.dart';
import '../services/ForegroundServices/CollectionForegroundService.dart';
import '../services/OauthKeySerivce.dart';
import '../services/SecureStorageWrapperService.dart';
import '../webview/SpotifyChoreSafariBrowser.dart';

Future<void> registerServices() async {
  final GetIt getIt = GetIt.I;
  getIt.registerFactory<SecureStorageServiceA>(
      () => SecureStorageWrapperService());
  getIt.registerFactory<OauthKeyServiceA>(
      () => SpotifyOauthKeyService(baseUrl: "https://auralia.fly.dev"));
  getIt.registerSingleton<AuthServiceA>(AuthService());
  await getIt<AuthServiceA>().init();
  getIt
      .registerFactory<ChromeSafariBrowser>(() => SpotifyChromeSafariBrowser());
  getIt.registerLazySingleton<DBServiceA>(() => IsarDBService());

  getIt.registerLazySingleton<CollectionForegroundServiceA>(
      () => CollectionForegroundService());
}
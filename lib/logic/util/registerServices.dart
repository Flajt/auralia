import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:auralia/logic/abstract/PathSeriveA.dart';
import 'package:auralia/logic/services/SpotifyService.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';

import '../abstract/AuthServiceA.dart';
import '../abstract/BehaviourUploadServiceA.dart';
import '../abstract/CollectionForegroundServiceA.dart';
import '../abstract/DBServiceA.dart';
import '../abstract/OauthKeyServiceA.dart';
import '../abstract/SecureStorageServiceA.dart';
import '../services/AuthService.dart';
import '../services/BehaviourUploadService.dart';
import '../services/DBService.dart';
import '../services/ForegroundServices/CollectionForegroundService.dart';
import '../services/OauthKeySerivce.dart';
import '../services/PathService.dart';
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
  getIt.registerFactory<BehaviourUploadServiceA>(
      () => BehaviourUploadService(getIt: getIt));
  getIt.registerSingleton<MusicServiceA>(SpotifyService());
  getIt.registerSingleton<PathServiceA>(PathService());
  await getIt<PathService>().init();
}

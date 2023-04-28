import 'package:auralia/logic/abstract/ActivityServiceA.dart';
import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:auralia/logic/abstract/NetworkingServiceA.dart';
import 'package:auralia/logic/abstract/PathSeriveA.dart';
import 'package:auralia/logic/abstract/RecommendationServiceA.dart';
import 'package:auralia/logic/services/ActivityService.dart';
import 'package:auralia/logic/services/ForegroundServices/RecommendationForegroundService.dart';
import 'package:auralia/logic/services/LocationService.dart';
import 'package:auralia/logic/services/NetworkingService.dart';
import 'package:auralia/logic/services/PreprocessService.dart';
import 'package:auralia/logic/services/RecommendationService.dart';
import 'package:auralia/logic/services/SpotifyService.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';

import '../abstract/AuthServiceA.dart';
import '../abstract/BehaviourUploadServiceA.dart';
import '../abstract/CollectionForegroundServiceA.dart';
import '../abstract/DBServiceA.dart';
import '../abstract/OauthKeyServiceA.dart';
import '../abstract/PreprocessServiceA.dart';
import '../abstract/RecommendationForegroundServiceA.dart';
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
  getIt.registerSingleton<PathServiceA>(PathService());
  getIt.registerFactory<ActivityServiceA>(() => ActivityService());
  getIt.registerFactory<LocationServiceA>(() => LocationService());
  await getIt<PathServiceA>().init();
  getIt.registerFactory<SecureStorageServiceA>(
      () => SecureStorageWrapperService());
  getIt.registerFactory<OauthKeyServiceA>(
      () => SpotifyOauthKeyService(baseUrl: "https://auralia.fly.dev"));
  getIt.registerSingleton<AuthServiceA>(AuthService());
  await getIt<AuthServiceA>().init();
  getIt
      .registerFactory<ChromeSafariBrowser>(() => SpotifyChromeSafariBrowser());

  getIt.registerLazySingleton<DBServiceA>(() => IsarDBService());
  await getIt<DBServiceA>().init();
  getIt.registerLazySingleton<CollectionForegroundServiceA>(
      () => CollectionForegroundService());
  getIt.registerFactory<BehaviourUploadServiceA>(
      () => BehaviourUploadService(getIt: getIt));
  getIt.registerSingleton<MusicServiceA>(SpotifyService());
  getIt.registerFactory<PreprocessServiceA>(() => PreprocessService());
  getIt.registerFactory<NetworkingServiceA>(() => NetworkingService());
  getIt.registerFactory<RecommendationServiceA>(() => RecommendationService());
  getIt.registerLazySingleton<RecommendationForegroundServiceA>(
      () => RecommendationForegroundService());
}

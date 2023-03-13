import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'package:async/async.dart';
import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:auralia/logic/services/LocationService.dart';
import 'package:auralia/logic/services/OauthKeySerivce.dart';
import 'package:auralia/logic/services/SecureStorageWrapperService.dart';
import 'package:auralia/logic/util/SpotifyUtil.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/logic/util/initSentry.dart';
import 'package:auralia/logic/util/initSuperbase.dart';
import 'package:auralia/logic/workerServices/collectionService.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:auralia/models/regular/LocationModel.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

import '../services/DBService.dart';
import '../util/tokenRefresh.dart';

@pragma('vm:entry-point')
void entryPoint() {
  FlutterForegroundTask.setTaskHandler(CollectionHandler());
}

class CollectionHandler extends TaskHandler {
  late final FlutterActivityRecognition _activityService;
  SpotifyOauthKeyService _keyService = SpotifyOauthKeyService(
      jwt: "jwt", storageWrapperService: SecureStorageWrapperService());
  String _accessToken = "";
  StreamSubscription? _sub;
  String _latestActivity = ActivityType.UNKNOWN.name;
  late final LocationServiceA _locationService;
  String _latestSong = "";
  final DBServiceA _dbService = IsarDBService();
  final Queue<DateTime> timerQueue = Queue();
  ListeningBehaviourModel? lastSong;
  final Stream<int> _timerStream =
      Stream.periodic(const Duration(minutes: 50), (eventCount) => eventCount);
  final SecureStorageWrapperService secureStorageWrapperService =
      SecureStorageWrapperService();
  StreamSubscription? _timerSub;
  CollectionHandler() {
    _activityService = FlutterActivityRecognition.instance;
    _locationService = LocationService();
  }

  Future<void> initServices() async {
    await initSentry();
    if (Platform.isIOS) {
      String jwt =
          (await initSupabase()).client.auth.currentSession!.accessToken;
      _keyService = SpotifyOauthKeyService(
          jwt: jwt,
          storageWrapperService: SecureStorageWrapperService(),
          baseUrl: "https://auralia.fly.dev");
    }
    _accessToken = (await _keyService.accessToken)!;
    await SpotifySdk.connectToSpotifyRemote(
        clientId: "8faad74f47d8448d863224389ba98e8f",
        redirectUrl: "background://auralia",
        accessToken: _accessToken);
    await registerOAuthUpdate();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await _sub?.cancel();
    await _timerSub?.cancel();
    await SpotifySdk.disconnect();
    await Workmanager().cancelByTag("update");
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    bool hasError = false;
    try {
      await initServices();
      Stream myStreams = StreamGroup.merge([
        SpotifySdk.subscribePlayerState(),
        _activityService.activityStream,
        _timerStream
      ]);
      _sub = myStreams.listen((event) async {
        try {
          if (event is int && Platform.isIOS) {
            await tokenRefresh(_keyService);
            await FlutterForegroundTask.restartService();
          } else if (event is Activity) {
            _latestActivity = event.type.name;
          } else if (event is PlayerState) {
            if (event.track?.isPodcast == false &&
                event.track?.isEpisode == false &&
                _latestSong != event.track?.name) {
              DateTime currentTime = DateTime.now();
              if (timerQueue.isNotEmpty) {
                Duration difference =
                    currentTime.difference(timerQueue.removeFirst());
                if (difference >= const Duration(seconds: 30) &&
                    lastSong != null) {
                  await _dbService.put(lastSong!);
                }
              }
              timerQueue.add(currentTime);
              _latestSong = event.track!.name;

              LocationModel locationModel =
                  await _locationService.getCurrentLocation();
              List<String> artists = event.track!.artists
                  .map((artist) => artist.uri!.split(":").last)
                  .toList();

              //has length one
              List<ListeningBehaviourModel> behaviourModel =
                  await SpotifyUtil.extractArtistsAndGenres(
                      _accessToken, artists, true);

              lastSong = behaviourModel.first.copyWith(
                  latitude: locationModel.latitude,
                  longitude: locationModel.longitude,
                  activity: _latestActivity);
            }
          }
          if (hasError) {
            await FlutterForegroundTask.updateService(
                notificationTitle: "Collecting",
                notificationText: "Collecting your music choice");
            hasError = false;
          }
        } catch (e, stack) {
          hasError = true;
          if (e is Map) {
            String error = e["error"]["message"];
            await FlutterForegroundTask.updateService(
                notificationTitle: "ERROR", notificationText: error);
          }
          bool hasNet = await InternetUtil.hasInternet();
          await Sentry.addBreadcrumb(Breadcrumb(
              message: "ForegroundService error 1",
              data: {"hasInternet": hasNet},
              level: SentryLevel.info));
          await Sentry.captureException(e, stackTrace: stack);
          await FlutterForegroundTask.updateService(
              notificationTitle: "ERROR", notificationText: e.toString());
        }
      });
    } catch (e, stack) {
      bool hasNet = await InternetUtil.hasInternet();
      await Sentry.addBreadcrumb(Breadcrumb(
          message: "ForegroundService error 2",
          data: {"hasInternet": hasNet},
          level: SentryLevel.info));
      hasError = true;
      await Sentry.captureException(e, stackTrace: stack);
      await FlutterForegroundTask.updateService(
          notificationTitle: "Error", notificationText: e.toString());
    }
  }

  Future<void> registerOAuthUpdate() async {
    if (Platform.isAndroid) {
      await Workmanager().initialize(updateOauthAccessToken);
      await Workmanager().registerPeriodicTask(
          "auralia_oauth_update_service", "Updates Spotify Access Token",
          tag: "update",
          constraints: Constraints(networkType: NetworkType.connected),
          initialDelay: const Duration(minutes: 5),
          frequency: const Duration(minutes: 50));
    }
  }
}

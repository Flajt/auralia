import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'package:async/async.dart';
import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:auralia/logic/services/LocationService.dart';
import 'package:auralia/logic/services/OauthKeySerivce.dart';
import 'package:auralia/logic/services/SecureStorageWrapperService.dart';
import 'package:auralia/logic/util/SpotifyUtil.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:auralia/models/regular/LocationModel.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../services/DBService.dart';

@pragma('vm:entry-point')
void entryPoint() {
  FlutterForegroundTask.setTaskHandler(CollectionHandler());
}

class CollectionHandler extends TaskHandler {
  late final FlutterActivityRecognition _activityService;
  late final SpotifyOauthKeyService _keyService;
  String? _accessToken;
  StreamSubscription? _sub;
  String _latestActivity = ActivityType.UNKNOWN.name;
  late final LocationServiceA _locationService;
  String _latestSong = "";
  final DBServiceA _dbService = IsarDBService();
  final Queue<DateTime> timerQueue = Queue();
  ListeningBehaviourModel? lastSong;

  CollectionHandler() {
    _activityService = FlutterActivityRecognition.instance;
    _locationService = LocationService();
    _keyService = SpotifyOauthKeyService(
        jwt: "jwt", storageWrapperService: SecureStorageWrapperService());
  }

  Future<void> initServices() async {
    _accessToken = await _keyService.accessToken!;
    await SpotifySdk.connectToSpotifyRemote(
        clientId: "8faad74f47d8448d863224389ba98e8f",
        redirectUrl: "background://auralia",
        accessToken: _accessToken!);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await _sub?.cancel();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    try {
      await initServices();
      Stream myStreams = StreamGroup.merge(
          [SpotifySdk.subscribePlayerState(), _activityService.activityStream]);
      _sub = myStreams.listen((event) async {
        if (event is Activity) {
          _latestActivity = event.type.name;
        } else if (event is PlayerState) {
          if (event.track?.isPodcast == false &&
              event.track?.isEpisode == false &&
              _latestSong != event.track?.name) {
            DateTime currentTime = DateTime.now();
            if (timerQueue.isNotEmpty) {
              Duration difference =
                  currentTime.difference(timerQueue.removeFirst());
              if (difference >= const Duration(seconds: 30)) {
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
                    _accessToken!, artists, true);

            lastSong = behaviourModel.first.copyWith(
                latitude: locationModel.latitude,
                longitude: locationModel.longitude,
                activity: _latestActivity);
          }
        }
      });
      _sub?.onError((error) => FlutterForegroundTask.updateService(
          notificationTitle: "ERROR", notificationText: error.toString()));
    } catch (e, stack) {
      FlutterForegroundTask.updateService(
          notificationTitle: "Error", notificationText: e.toString());
    }
  }
}

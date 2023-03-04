import 'dart:async';
import 'dart:isolate';
import 'package:async/async.dart';
import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:auralia/logic/services/LocationService.dart';
import 'package:auralia/logic/util/SpotifyUtil.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:auralia/models/regular/LocationModel.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/DBService.dart';

@pragma('vm:entry-point')
void entryPoint() {
  FlutterForegroundTask.setTaskHandler(CollectionHandler());
}

class CollectionHandler extends TaskHandler {
  late final FlutterActivityRecognition _activityService;
  Supabase? _supabase;
  String? _accessToken;
  StreamSubscription? _sub;
  String _latestActivity = ActivityType.UNKNOWN.name;
  late final LocationServiceA _locationService;
  String _latestSong = "";
  final DBServiceA _dbService = IsarDBService();

  CollectionHandler() {
    _activityService = FlutterActivityRecognition.instance;
    _locationService = LocationService();
  }

  Future<void> initServices() async {
    _supabase = await Supabase.initialize(
        url: "https://limbadcemvavrnorbkig.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpbWJhZGNlbXZhdnJub3Jia2lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzY5ODYzNTYsImV4cCI6MTk5MjU2MjM1Nn0.RgD8isCOgvIADI9Yv9iifhFi1grpwzZYP-BGIeXXzJM");

    _accessToken = _supabase!.client.auth.currentSession!.providerToken!;
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
      sendPort?.send("gogogog");
      Stream myStreams = StreamGroup.merge(
          [SpotifySdk.subscribePlayerState(), _activityService.activityStream]);

      sendPort?.send("lets go super mario");
      _sub = myStreams.listen((event) async {
        if (event is Activity) {
          _latestActivity = event.type.name;
        } else if (event is PlayerState) {
          if (event.track?.isPodcast == false &&
              event.track?.isEpisode == false &&
              _latestSong != event.track?.name) {
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

            ListeningBehaviourModel updatedModel = behaviourModel.first
                .copyWith(
                    latitude: locationModel.latitude,
                    longitude: locationModel.longitude,
                    activity: _latestActivity);
            await _dbService.put(updatedModel);
          }
        }
      });
      _sub?.onError((error) => FlutterForegroundTask.updateService(
          notificationTitle: "ERROR", notificationText: error.toString()));
    } catch (e, stack) {
      FlutterForegroundTask.updateService(
          notificationTitle: "Error", notificationText: e.toString());
      sendPort?.send(e.toString());
    }
  }
}

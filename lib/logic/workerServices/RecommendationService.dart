import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:auralia/logic/abstract/RecommendationServiceA.dart';
import 'package:auralia/logic/services/LocationService.dart';
import 'package:auralia/models/PlayerStateModel.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/regular/LocationModel.dart';
import '../abstract/AuthServiceA.dart';
import '../abstract/OauthKeyServiceA.dart';
import '../abstract/RecommendationForegroundServiceA.dart';
import '../services/ForegroundServices/RecommendationForegroundService.dart';
import '../util/InternetUtil.dart';
import '../util/initSentry.dart';
import '../util/registerServices.dart';

@pragma('vm:entry-point')
void entryPoint() {
  FlutterForegroundTask.setTaskHandler(RecommendationHandler());
}

///CURRENTLY NOT WORKING
///PREDICT SEEMS TO NOT WORK
///Consider sending what to play via the sendPort in the future so it can be run by the PlayerBloc
class RecommendationHandler extends TaskHandler {
  final _getIt = GetIt.I;
  MusicServiceA? _musicService;
  final RecommendationForegroundServiceA _recommendationForegroundService =
      RecommendationForegroundService();
  StreamSubscription? _sub;
  String _latestSong = "";
  String _latestActivity = ActivityType.UNKNOWN.name;
  String _accessToken = "";
  final Stream<int> _timerStream =
      Stream.periodic(const Duration(minutes: 50), (eventCount) => eventCount);
  final _activityService = FlutterActivityRecognition.instance;
  final LocationServiceA _locationService = LocationService();
  RecommendationServiceA? _recommendationService;
  String _newId = "";

  Future<void> initServices() async {
    await initSentry();
    await registerServices();
    _recommendationService = _getIt<RecommendationServiceA>();
    _musicService = _getIt<MusicServiceA>();
    await _musicService!.init();
    _accessToken = (await _getIt<OauthKeyServiceA>().accessToken)!;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    _sub?.cancel();
    _musicService?.disconnect();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    bool hasError = false;
    try {
      await initServices();

      Stream myStreams = StreamGroup.merge([
        _musicService!.subscribePlayerState(),
        _activityService.activityStream,
        _timerStream
      ]);

      _sub = myStreams.listen((event) async {
        try {
          if (event is int) {
            await _getIt<AuthServiceA>().refreshAccessToken();
            await _recommendationForegroundService.restartService();
          } else if (event is Activity) {
            _latestActivity = event.type.name;
          } else if (event is PlayerStateModel) {
            if (event.isPaused == false &&
                event.isSong == true &&
                _newId != event.id &&
                _latestSong != event.songName) {
              if (hasError) {
                await _recommendationForegroundService.updateService(
                    "Collecting", "Collecting your music choice");
                hasError = false;
              }
              _latestSong = event.songName;
              _newId = await recommend();
              await _musicService!.play(_newId);
            }
          } else if (_newId == "") {
            _newId = await recommend();
            await _musicService!.play(_newId);
          }
        } catch (e, stack) {
          if (e is String && e.contains("status")) {
            Map errorMsg = jsonDecode(e);
            String error = errorMsg["error"]["message"];
            await _recommendationForegroundService.updateService(
                "ERROR", error.toString());
          } else {
            bool hasNet = await InternetUtil.hasInternet();
            await Sentry.addBreadcrumb(Breadcrumb(
                message: "ForegroundService error 1",
                data: {"hasInternet": hasNet},
                level: SentryLevel.info));
            await Sentry.captureException(e, stackTrace: stack);
            await _recommendationForegroundService.updateService(
                "ERROR", e.toString());
          }
        }
      });
    } catch (e, stack) {
      bool hasNet = await InternetUtil.hasInternet();
      await Sentry.addBreadcrumb(Breadcrumb(
          message: "ForegroundService error 3",
          data: {"hasInternet": hasNet},
          level: SentryLevel.info));
      hasError = true;
      await Sentry.captureException(e, stackTrace: stack);
      await _recommendationForegroundService.updateService(
          "Error", e.toString());
    }
  }

  Future<String> recommend() async {
    LocationModel locationModel = await _locationService.getCurrentLocation();
    String id = await _recommendationService!.recommend(
        locationModel.latitude, locationModel.longitude, _latestActivity);
    return id.split(":").last;
  }
}

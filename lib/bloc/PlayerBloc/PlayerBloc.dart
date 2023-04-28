import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:auralia/bloc/PlayerBloc/PlayerEvents.dart';
import 'package:auralia/bloc/PlayerBloc/PlayerState.dart';
import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:auralia/logic/abstract/LocationServiceA.dart';
import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:auralia/logic/abstract/RecommendationForegroundServiceA.dart';
import 'package:auralia/logic/workerServices/RecommendationService.dart'
    show entryPoint;
import 'package:auralia/logic/abstract/RecommendationServiceA.dart';
import 'package:auralia/logic/abstract/models/PlayerStateModelA.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../logic/abstract/ActivityServiceA.dart';
import '../../models/regular/LocationModel.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetIt _getIt = GetIt.I;
  late final MusicServiceA _musicService;
  late final AuthServiceA _authService;
  late final RecommendationServiceA _recommendationService;
  late final LocationServiceA _locationService;
  late final RecommendationForegroundServiceA _foregroundService;
  late final ActivityServiceA _activityService;
  final Stream<int> _refreshTokenCounterStream =
      Stream.periodic(const Duration(minutes: 50), (count) => count);
  late final StreamSubscription<int> _refreshTokenSub;
  String nextSongId = "";
  StreamSubscription? _testSub;

  PlayerBloc() : super(InitalPlayerState()) {
    _musicService = _getIt<MusicServiceA>();
    _authService = _getIt<AuthServiceA>();
    _foregroundService = _getIt<RecommendationForegroundServiceA>();
    _foregroundService.init();
    _refreshTokenSub =
        _refreshTokenCounterStream.listen((event) => add(IRestart()));
    _recommendationService = _getIt<RecommendationServiceA>();
    _activityService = _getIt<ActivityServiceA>();
    _locationService = _getIt<LocationServiceA>();

    on<InitPlayer>(_init, transformer: restartable());
    on<Play>(_onPlay);
    on<Stop>(_onStop);
    on<SkipBackwards>(_onSkipBackwards);
    on<SkipForward>(_onSkipForward);
    on<IRestart>(_restart);
  }
  Future<void> _init(PlayerEvent event, Emitter<PlayerState> emitter) async {
    try {
      if (state is InitalPlayerState || state is IsRestarting) {
        emitter(InitalizingPlayer());
        await _musicService.init();
        emitter(HasInitalizedPlayer());
        bool isActive = await _musicService.isActive;
        bool isIOS = Platform.isIOS;

        if (isIOS) {
          if (isActive) {
            return emitter.forEach<PlayerStateModelA>(
                _musicService.subscribePlayerState(), onData: (data) {
              return data.isPaused ? IsPaused(data) : IsPlayingSong(data);
            });
          }
        } else {
          return emitter.forEach<PlayerStateModelA>(
              _musicService.subscribePlayerState(), onData: (data) {
            return data.isPaused ? IsPaused(data) : IsPlayingSong(data);
          });
        }
      }
    } catch (e, stackT) {
      emitter(PlayerHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }

  _onPlay(PlayerEvent event, Emitter<PlayerState> emitter) async {
    try {
      if (state is HasInitalizedPlayer) {
        String id = await _getRecommendation();
        await _musicService.play(id);
        final currentState = await _musicService.subscribePlayerState().first;
        emitter(IsPlayingSong(currentState));
      } else if (state is IsPaused) {
        await _musicService.resume();
        IsPaused currenState = state as IsPaused;
        emitter(IsPlayingSong(currenState.playerState));
      } else if (state is IsPlayingSong) {
        final currentState = await _musicService.subscribePlayerState().first;
        emitter(IsPlayingSong(currentState));
      } else if (state is HasInitalizedPlayer && Platform.isIOS) {
        add(InitPlayer());
      } else if (state is PlayerHasError) {
        add(InitPlayer());
      }
    } catch (e, stackT) {
      emitter(PlayerHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }

  Future<Uint8List?> getImageBytes(PlayerStateModelA currentState) async {
    Uint8List? imageBytes;
    if (currentState.imageUri != null) {
      imageBytes = await _musicService.getImage(currentState.imageUri!);
    }
    return imageBytes;
  }

  _onStop(PlayerEvent event, Emitter<PlayerState> emitter) async {
    try {
      if (state is IsPlayingSong) {
        await _foregroundService.stopService();
        await _musicService.pause();
        IsPlayingSong currentState = state as IsPlayingSong;
        emitter(IsPaused(currentState.playerState));
      }
    } catch (e, stackT) {
      emitter(PlayerHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }

  _onSkipBackwards(PlayerEvent event, Emitter<PlayerState> emitter) async {
    try {
      if (state is! InitalPlayerState || state is! InitalizingPlayer) {
        bool hasMoved = await _musicService.backward();
        final currentState = await _musicService.subscribePlayerState().first;
        if (hasMoved) {
          Uint8List? imageBytes = await getImageBytes(currentState);
          emitter(HasSkippedBackwards(currentState, imageBytes));
          emitter(IsPlayingSong(currentState));
        }
      }
    } catch (e, stackT) {
      emitter(PlayerHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }

  _onSkipForward(PlayerEvent event, Emitter emitter) async {
    try {
      if (state is! InitalPlayerState || state is! InitalizingPlayer) {
        String songId = await _getRecommendation();
        bool hasMoved = await _musicService.play(songId);
        await Future.delayed(const Duration(seconds: 1));
        final currentState = await _musicService.subscribePlayerState().first;
        if (hasMoved) {
          emitter(HasSkippedForward(currentState));
          emitter(IsPlayingSong(currentState));
        }
      }
    } catch (e, stackT) {
      emitter(PlayerHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }

  _restart(PlayerEvent event, Emitter emitter) async {
    try {
      await _authService.refreshAccessToken();
      await _musicService.disconnect();
      emitter(IsRestarting());
      add(InitPlayer());
    } catch (e, stackT) {
      emitter(PlayerHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }

  Future<String> _getRecommendation() async {
    const activites = [
      "IN_VEHICLE",
      "ON_BICYCLE",
      "RUNNING",
      "STILL",
      "WALKING",
      "UNKNOWN"
    ];

    LocationModel location = await _locationService.getCurrentLocation();
    String activity = activites[Random().nextInt(6)];
    return await _recommendationService.recommend(
        location.latitude, location.longitude, activity);
  }

  @override
  Future<void> close() async {
    await _refreshTokenSub.cancel();
    await _testSub?.cancel();
    await _musicService.disconnect();
    return super.close();
  }
}

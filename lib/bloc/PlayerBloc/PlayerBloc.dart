import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auralia/bloc/PlayerBloc/PlayerEvents.dart';
import 'package:auralia/bloc/PlayerBloc/PlayerState.dart';
import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:auralia/logic/abstract/models/PlayerStateModelA.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetIt _getIt = GetIt.I;
  late final MusicServiceA _musicService;
  late final AuthServiceA _authService;
  final Stream<int> _refreshTokenCounterStream =
      Stream.periodic(const Duration(minutes: 50), (count) => count);
  StreamSubscription? _refreshTokenSub;
  PlayerBloc() : super(InitalPlayerState()) {
    _musicService = _getIt<MusicServiceA>();
    _authService = _getIt<AuthServiceA>();
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
        await _musicService.init();
        _refreshTokenSub?.cancel();
        _refreshTokenSub =
            _refreshTokenCounterStream.listen((event) => add(IRestart()));
        emitter(InitalizingPlayer());
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
        bool hasMoved = await _musicService.forward();
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

  @override
  Future<void> close() async {
    _refreshTokenSub?.cancel();
    await _musicService.disconnect();
    return super.close();
  }
}

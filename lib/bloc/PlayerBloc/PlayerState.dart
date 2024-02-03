import 'dart:typed_data';

import 'package:auralia/logic/abstract/models/PlayerStateModelA.dart';
import 'package:equatable/equatable.dart';

abstract class PlayerState extends Equatable {}

class InitalPlayerState extends PlayerState {
  @override
  List<Object?> get props => [];
}

class IsPlayingSong extends PlayerState {
  final PlayerStateModelA playerState;

  IsPlayingSong(this.playerState);
  @override
  List<Object?> get props => [playerState];
}

class IsPaused extends PlayerState {
  final PlayerStateModelA playerState;
  IsPaused(this.playerState);

  @override
  List<Object?> get props => [playerState];
}

class HasSkippedForward extends PlayerState {
  final PlayerStateModelA playerState;

  HasSkippedForward(this.playerState);

  @override
  List<Object?> get props => [playerState];
}

class HasSkippedBackwards extends PlayerState {
  final PlayerStateModelA playerState;
  final Uint8List? imageBytes;

  HasSkippedBackwards(this.playerState, this.imageBytes);
  @override
  List<Object?> get props => [playerState, imageBytes];
}

class PlayerHasError extends PlayerState {
  final String errorMsg;
  final dynamic stackT;

  PlayerHasError({required this.errorMsg, this.stackT});

  @override
  List<Object?> get props => [errorMsg, stackT];
}

class InitalizingPlayer extends PlayerState {
  @override
  List<Object?> get props => [null];
}

class HasInitalizedPlayer extends PlayerState {
  @override
  List<Object?> get props => [];
}

class IsRestarting extends PlayerState {
  @override
  List<Object?> get props => [];
}

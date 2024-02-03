import 'dart:async';
import 'dart:typed_data';

import 'package:auralia/logic/abstract/models/PlayerStateModelA.dart';

abstract class MusicServiceA {
  Future<void> init();
  Future<bool> resume();
  Future<bool> play(String id);
  Future<bool> pause();
  Future<bool> forward();
  Future<bool> backward();
  Future<void> disconnect();
  Future<Uint8List> getImage(String uri);
  Future<bool> get isActive;
  Stream<PlayerStateModelA> subscribePlayerState();
}

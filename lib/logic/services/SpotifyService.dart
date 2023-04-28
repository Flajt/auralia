import 'dart:async';
import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:auralia/logic/abstract/OauthKeyServiceA.dart';
import 'package:auralia/models/PlayerStateModel.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_sdk/models/artist.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyService implements MusicServiceA {
  final GetIt _getIt = GetIt.I;

  @override
  Future<bool> backward() async {
    try {
      await SpotifySdk.skipPrevious();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return false;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> disconnect() async {
    await SpotifySdk.disconnect();
  }

  @override
  Future<bool> forward() async {
    try {
      await SpotifySdk.skipNext();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return false;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> init() async {
    String? providerToken = await _getIt<OauthKeyServiceA>().accessToken;
    await SpotifySdk.connectToSpotifyRemote(
        clientId: "8faad74f47d8448d863224389ba98e8f",
        redirectUrl: "background://auralia",
        accessToken: providerToken!);
  }

  @override
  Future<bool> pause() async {
    try {
      await SpotifySdk.pause();
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return false;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<bool> resume() async {
    await SpotifySdk.resume();
    return true;
  }

  @override
  Stream<PlayerStateModel> subscribePlayerState() {
    return SpotifySdk.subscribePlayerState().map<PlayerStateModel>((event) {
      return PlayerStateModel(
          isSong: event.track?.isEpisode ?? false
              ? false
              : event.track?.isPodcast ?? false
                  ? false
                  : true,
          id: event.track?.uri.split(":").last ?? "",
          isPaused: event.isPaused,
          songName: event.track?.name ?? "UNKNOWN",
          imageUri: event.track?.imageUri.raw,
          artists: _convertArtistsToId([
            event.track?.artist ?? Artist("", ""),
            ...event.track?.artists ?? []
          ]));
    });
  }

  List<String> _convertArtistsToId(List<Artist> artists) {
    return artists.map((e) => e.uri!.split(":").last).toList();
  }

  @override
  Future<bool> play(String id) async {
    await SpotifySdk.play(spotifyUri: id);
    return true;
  }

  @override
  Future<Uint8List> getImage(String uri) async {
    final imageBytes = await SpotifySdk.getImage(imageUri: ImageUri(uri));
    return imageBytes!;
  }

  @override
  Future<bool> get isActive async => await SpotifySdk.isSpotifyAppActive;
}

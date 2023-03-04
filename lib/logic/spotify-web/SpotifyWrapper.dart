import 'package:chopper/chopper.dart';
import 'package:spotify_web_api/generated/SpotifyWeb.swagger.dart';
import 'package:spotify_web_api/spotify_web_api.dart';

class SpotifyWrapper {
  late final SpotifyWeb spotifyWeb;
  SpotifyWrapper(String jwt) {
    spotifyWeb = SpotifyWeb.create(
        interceptors: [SpotifyAuthInterceptor(jwt)],
        baseUrl: Uri.parse("https://api.spotify.com/v1"));
  }

  ///Get's users most recently played tracks
  Future<List<dynamic>> getRecentlyPlayedTracks(
      [int? after, int? before]) async {
    Response<Object> recentlyPlayedSongsRq = await spotifyWeb
        .mePlayerRecentlyPlayedGet(limit: 50, after: after, before: before);
    if (recentlyPlayedSongsRq.isSuccessful) {
      final List<dynamic> tracks =
          (recentlyPlayedSongsRq.body as Map<String, dynamic>)["items"];
      return tracks;
    } else {
      throw recentlyPlayedSongsRq.error.toString();
    }
  }

  ///Uses Artists Ids to get genres
  Future<Map<String, List<String>>> getGenres(List<String> artistIds) async {
    Response<ManyArtists> artistReq =
        await spotifyWeb.artistsGet(ids: artistIds.join(","));
    if (artistReq.isSuccessful) {
      Map<String, List<String>> artistGenreMapping = {};
      for (var element in artistReq.body!.artists) {
        artistGenreMapping[element.id!] = element.genres!;
      }
      return artistGenreMapping;
    } else {
      throw artistReq.error.toString();
    }
  }
}

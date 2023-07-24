import 'package:auralia/models/RecommendedTrackModel.dart';
import 'package:chopper/chopper.dart';
import 'package:spotify_web_api/generated/spotify_web.swagger.dart';
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

  Future<String> getUserMarket() async {
    Response resp = await spotifyWeb.meGet();
    if (resp.isSuccessful) {
      return resp.body["country"];
    } else {
      throw resp.error.toString();
    }
  }

  Future<List<RecommendedTrackModel>> getRecommendation(
      String seedGenres, String market, String artists) async {
    try {
      Response recommendationReq = await spotifyWeb.recommendationsGet(
          limit: 10,
          seedGenres: seedGenres,
          market: market,
          seedArtists: artists);

      if (recommendationReq.isSuccessful) {
        List<RecommendedTrackModel> recommendations = [];
        List<Map<dynamic, dynamic>> tracks =
            List.from(recommendationReq.body["tracks"]);
        for (Map<dynamic, dynamic> element in tracks) {
          if (element != null) {
            recommendations.add(RecommendedTrackModel.fromJson(
                element as Map<String, dynamic>));
          }
        }
        List<RecommendedTrackModel> updatedModels = [];
        for (var model in recommendations) {
          Map<String, List<String>> artistsGenreMapping =
              await getGenres(model.artists);
          List<String> genres =
              artistsGenreMapping.values.expand((element) => element).toList();
          updatedModels.add(model.copywith(genres: genres));
        }
        return updatedModels;
      } else {
        throw recommendationReq.error.toString();
      }
    } catch (e, s) {
      print(s);
      print(e);
      rethrow;
    }
  }
}

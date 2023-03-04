import '../../models/regular/ListeningBehaviourModel.dart';
import '../spotify-web/SpotifyWrapper.dart';

class SpotifyUtil {
  static Future<Map<String, List<String>>> getLatestUserArtistsAndGenres(
    String jwt,
  ) async {
    final wrapper = SpotifyWrapper(jwt);
    List<dynamic> userTracks = await wrapper.getRecentlyPlayedTracks();
    List<String> authors = [];
    for (dynamic userTrack in userTracks) {
      authors.addAll((userTrack["track"]["artists"] as List<dynamic>)
          .map((e) => e["id"])
          .toList() as List<String>);
    }
    Map<String, List<String>> artistGenreMapping =
        await wrapper.getGenres(authors);
    return artistGenreMapping;
  }

  static Future<List<ListeningBehaviourModel>> extractArtistsAndGenres(
      String jwt, List<dynamic> userTracks,
      [bool isSdkTrack = false]) async {
    final wrapper = SpotifyWrapper(jwt);
    List<ListeningBehaviourModel> models = [];
    List<String> trackArtists = [];
    for (var userTrack in userTracks) {
      if (!isSdkTrack) {
        trackArtists = List.from(
            (userTrack["track"]["artists"] as List<dynamic>)
                .map((e) => e["id"])
                .toList());
      } else {
        trackArtists = userTracks as List<String>;
      }
      Map<String, List<String>> artistGenreMapping =
          await wrapper.getGenres(trackArtists);
      List<String> genres = artistGenreMapping.values.reduce((value, element) {
        value.addAll(element);
        return value;
      });
      models.add(ListeningBehaviourModel(
          trackArtists,
          genres,
          0.0,
          0.0,
          "UNKNOWN", // Currently empty
          isSdkTrack
              ? DateTime.now().millisecondsSinceEpoch
              : DateTime.parse(userTrack["played_at"] as String)
                  .millisecondsSinceEpoch));
    }
    return models;
  }
}

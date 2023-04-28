import 'dart:math';

import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/abstract/NetworkingServiceA.dart';
import 'package:auralia/logic/abstract/OauthKeyServiceA.dart';
import 'package:auralia/logic/abstract/PreprocessServiceA.dart';
import 'package:auralia/logic/spotify-web/SpotifyWrapper.dart';
import 'package:auralia/models/RecommendedTrackModel.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:get_it/get_it.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/vector.dart';

import '../abstract/RecommendationServiceA.dart';

///Depends on:
///- DBServiceA
///- PreprocessServiceA
///- NetworkingServiceA
///- OauthServiceA
class RecommendationService extends RecommendationServiceA {
  final _getIt = GetIt.I;
  late final DBServiceA _db;
  late final PreprocessServiceA _preprocessService;
  late final NetworkingServiceA _networkingService;
  late final OauthKeyServiceA _oauthKeyService;

  RecommendationService() {
    _db = _getIt<DBServiceA>();
    _preprocessService = _getIt<PreprocessServiceA>();
    _networkingService = _getIt<NetworkingServiceA>();
    _oauthKeyService = _getIt<OauthKeyServiceA>();
  }

  @override
  Future<List<double>> _chooseBestSong(
      List<Vector> history, List<Vector> recommendations) async {
    Vector repVector =
        history.reduce((value, element) => value + element) / history.length;
    List<double> ranking =
        recommendations.map((e) => e.distanceTo(repVector)).toList();
    return ranking;
  }

  @override
  Future<String> recommend(double lat, double long, String activity) async {
    String? jwt = await _oauthKeyService.accessToken;
    List<ListeningBehaviourModel> listeningHistory = await _db.getAll();
    //TODO: Find better way to handle this, the token might run out, this is why it needs to be fetched every recommendation
    SpotifyWrapper spotifyWrapper = SpotifyWrapper(jwt!);
    int dateTimeInMis = DateTime.now().toUtc().millisecondsSinceEpoch;
    int processedActivity = _preprocessService.activityConverter(activity);
    String artist = listeningHistory.first.artists.first;
    List<String> genres = await _networkingService.getGenreRecommendation(
        lat: lat,
        long: long,
        activity: processedActivity,
        dateTimeInMis: dateTimeInMis);
    String market = await spotifyWrapper.getUserMarket();
    List<RecommendedTrackModel> recommendedSongs =
        await spotifyWrapper.getRecommendation(
            genres.sublist(0, genres.length > 3 ? 3 : genres.length).join(","),
            market,
            artist);
    if (listeningHistory.isEmpty || listeningHistory.length < 3) {
      return recommendedSongs[Random().nextInt(10)].id;
    }
    List<Vector> proccessedListeningHistory =
        await _preprocessService.behavioursToVectors(listeningHistory);
    List<ListeningBehaviourModel> lbms = [];
    //TODO Use map
    for (RecommendedTrackModel model in recommendedSongs) {
      lbms.add(ListeningBehaviourModel(
          model.artists,
          model.genres,
          lat,
          long,
          activity,
          dateTimeInMis,
          model.id
              .split(":")
              .last)); //This is because we store the whole uri, not only the id
    }
    List<Vector> preprocessedRecommendations =
        await _preprocessService.behavioursToVectors(lbms);
    List<double> rankingList = await _chooseBestSong(
        proccessedListeningHistory, preprocessedRecommendations);
    int bestSongIndex = findMin(rankingList);
    print(bestSongIndex);
    print(recommendedSongs);
    return recommendedSongs[bestSongIndex].id;
  }

  ///Returns index of the smallest elemnt
  /// With a speed of O(n) max lenght 10 entries
  int findMin(List<double> rankingList) {
    int smallestIndex = 0;
    for (int i = 1; i < rankingList.length; i++) {
      if (rankingList[i] < rankingList[smallestIndex]) {
        smallestIndex = i;
      }
    }
    return smallestIndex;
  }
}

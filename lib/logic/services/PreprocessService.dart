import 'package:auralia/logic/abstract/PreprocessServiceA.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/vector.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

class PreprocessService extends PreprocessServiceA {
  @override
  Vector behaviourToVector(
      ListeningBehaviourModel behaviourModel, Encoder oneHotEncoder) {
    int convertedActivity = activityConverter(behaviourModel.activity);
    DataFrame artistDF =
        DataFrame.fromSeries([Series("artists", behaviourModel.artists)]);
    DataFrame genreDF =
        DataFrame.fromSeries([Series("genres", behaviourModel.genres)]);
    DataFrame oneHotArtists = oneHotEncoder.process(artistDF);
    DataFrame oneHotGenres = oneHotEncoder.process(genreDF);
    //final oneHotGenres = processedDF["genres"];
    //final oneHotArtists = processedDF["artists"];
    double genresAsAverage = 0;
    if (behaviourModel.genres.isNotEmpty) {
      genresAsAverage = oneHotGenres.series
              .map((e) =>
                  List.from(e.data).reduce((value, element) => value + element))
              .toList()
              .reduce((value, element) => value + element) /
          oneHotGenres.series.length;
    }
    double artistsAsAverage = oneHotArtists.series
            .map((e) =>
                List.from(e.data).reduce((value, element) => value + element))
            .toList()
            .reduce((value, element) => value + element) /
        oneHotArtists.series.length;

    return Vector.fromList([
      behaviourModel.latitude,
      behaviourModel.longitude,
      convertedActivity,
      behaviourModel.dateTimeInMis,
      artistsAsAverage,
      genresAsAverage
    ]);
  }

  @override
  Future<List<Vector>> behavioursToVectors(
      List<ListeningBehaviourModel> behaviourModels) async {
    Set<String> genres = {};
    Set<String> artists = {};
    behaviourModels.forEach((element) {
      genres.addAll(element.genres);
      artists.addAll(element.artists);
    });
    Series genreSeries = Series("genres", genres);
    Series artistSeries = Series("artists", artists);
    DataFrame dataFrame = DataFrame.fromSeries([genreSeries, artistSeries]);
    Encoder oneHotEncoder =
        Encoder.oneHot(dataFrame, columnNames: ["genres", "artists"]);
    return behaviourModels
        .map((model) => behaviourToVector(model, oneHotEncoder))
        .toList();
  }
}

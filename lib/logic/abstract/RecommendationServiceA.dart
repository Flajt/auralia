import 'package:ml_linalg/vector.dart';

abstract class RecommendationServiceA {
  Future<String> recommend(double lat, double long, String activity);
  Future<List<double>> _chooseBestSong(
      List<Vector> history, List<Vector> recommendations);
}

import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

import '../../models/regular/ListeningBehaviourModel.dart';

abstract class PreprocessServiceA {
  Future<List<Vector>> behavioursToVectors(
      List<ListeningBehaviourModel> behaviourModels);
  Vector behaviourToVector(
      ListeningBehaviourModel behaviourModel, Encoder oneHotEncoder);
  int activityConverter(String activity) {
    switch (activity) {
      case "UNKNOWN":
        return 0;
      case "WALKING":
        return 1;
      case "STILL":
        return 2;
      case "RUNNING":
        return 3;
      case "ON_BICYCLE":
        return 4;
      case "IN_VEHICLE":
        return 5;
      default:
        return 0;
    }
  }
}

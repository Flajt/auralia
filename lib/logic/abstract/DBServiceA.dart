import 'package:auralia/models/regular/ListeningBehaviourModel.dart';

abstract class DBServiceA {
  Future<void> init();
  Future<List<ListeningBehaviourModel>> getRecent(int latestDTinMs);
  put(ListeningBehaviourModel model);
  update(ListeningBehaviourModel model);
  delete(ListeningBehaviourModel model);
  Future<void> close();
  Future<List<ListeningBehaviourModel>> getAll({bool sortAsc = false});
}

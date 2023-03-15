import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class IsarDBService extends DBServiceA {
  late final Isar _isar;
  IsarDBService() {
    Isar? isarInstance = Isar.getInstance();
    if (isarInstance != null) {
      _isar = isarInstance;
    } else {
      _isar =
          Isar.openSync([ListeningBehaviourModelSchema], inspector: kDebugMode);
    }
  }
  @override
  delete(ListeningBehaviourModel model) {
    _isar.writeTxn(() => _isar.listeningBehaviourModels.delete(model.id));
  }

  ///Not needed in this implementation
  @override
  Future<void> init() {
    throw UnimplementedError();
  }

  ///Puts  a [ListeningBehaviourModel] in the db
  @override
  put(ListeningBehaviourModel model) {
    _isar.writeTxn(() async => await _isar.listeningBehaviourModels.put(model));
  }

  ///Not needed, [put] does the same
  @override
  update(ListeningBehaviourModel model) {
    // TODO: implement update
    throw UnimplementedError();
  }

  ///Get's the recent [ListeningBehaviourModel]s from the DB
  ///Uses [latestDTInMs] to get everything aferwards
  @override
  Future<List<ListeningBehaviourModel>> getRecent(int? latestDTInMs) async {
    if (latestDTInMs == null) {
      ListeningBehaviourModel? model = await _isar.listeningBehaviourModels
          .filter()
          .idGreaterThan(0, include: true)
          .findFirst();
      if (model == null) {
        return [];
      } else {
        latestDTInMs = model.dateTimeInMis;
      }
    }
    List<ListeningBehaviourModel> data = await _isar.listeningBehaviourModels
        .filter()
        .dateTimeInMisGreaterThan(latestDTInMs)
        .findAll();
    return data;
  }

  @override
  Future<void> close() async {
    await _isar.close();
  }

  @override
  Future<List<ListeningBehaviourModel>> getAll({bool sortAsc = false}) async {
    final query =
        _isar.listeningBehaviourModels.filter().idGreaterThan(0, include: true);
    if (sortAsc) {
      return await query.sortByDateTimeInMis().findAll();
    } else {
      return await query.sortByDateTimeInMisDesc().findAll();
    }
  }
}

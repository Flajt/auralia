import 'package:isar/isar.dart';

import 'LocationModel.dart';

class ActivityLocationModel {
  final Id? id;
  final LocationModel locationModel;
  final String activity;
  final int timeStampInMs;

  ActivityLocationModel(
      this.locationModel, this.activity, this.timeStampInMs, this.id);
}

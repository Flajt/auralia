import 'package:auralia/logic/abstract/ActivityServiceA.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

class ActivityService implements ActivityServiceA {
  @override

  ///Gets the users current activity
  /// 0 = IN_VEHICLE,
  /// 1 = ON_BICYCLE,
  /// 2 = RUNNING,
  /// 3 = STILL,
  /// 4 = WALKING,
  /// 5 = UNKNOWN
  Future<int> getCurrentActivity() async {
    try {
      Activity currentActivity =
          await FlutterActivityRecognition.instance.activityStream.first;
      return currentActivity.type.index;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }
}

import 'dart:convert';

import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import '../../models/regular/ListeningBehaviourModel.dart';

class BehaviourUploadServices {
  final DBServiceA dbServiceA;
  final String baseUrl;
  //TODO: Create provider with basic values
  const BehaviourUploadServices(
      {required this.dbServiceA, this.baseUrl = "http://192.168.0.6:8000"});

  Future<int> get recentUploadTime async =>
      (await SharedPreferences.getInstance()).getInt("songTime") ??
      DateTime.now().toUtc().millisecondsSinceEpoch;

  Future<void> setRecentUploadTime(DateTime recentUploadTime) async {
    final instance = await SharedPreferences.getInstance();
    instance.setInt(
        "songTime", recentUploadTime.toUtc().millisecondsSinceEpoch);
  }

  Future<void> uploadSongs() async {
    List<ListeningBehaviourModel> listeningBehaviour =
        await dbServiceA.getRecent(await recentUploadTime);
    List<Map<String, dynamic>> jsonModels = [];
    for (ListeningBehaviourModel behaviour in listeningBehaviour) {
      jsonModels.add(behaviour.toJson());
    }
    if (jsonModels.isNotEmpty) {
      DateTime now = DateTime.now();
      http.Response resp = await http.post(Uri.parse("$baseUrl/add-songs"),
          body: jsonEncode({"behaviour": jsonModels}));
      if (resp.statusCode < 400) {
        await setRecentUploadTime(now);
      } else {
        throw "Can't upload songs!";
      }
    }
  }
}

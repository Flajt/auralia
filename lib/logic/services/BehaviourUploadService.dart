import 'dart:convert';

import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/logic/util/toUtcTime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import '../../models/regular/ListeningBehaviourModel.dart';

class BehaviourUploadService {
  final DBServiceA dbServiceA;
  final String baseUrl;
  final String jwt;
  //TODO: Create provider with basic values
  const BehaviourUploadService(
      {required this.dbServiceA,
      required this.jwt,
      this.baseUrl = "http://192.168.0.6:8000"});

  Future<int?> get recentUploadTime async =>
      (await SharedPreferences.getInstance()).getInt("songTime");

  Future<void> setRecentUploadTime(DateTime recentUploadTime) async {
    final instance = await SharedPreferences.getInstance();
    instance.setInt(
        "songTime", toUtcTime(recentUploadTime).millisecondsSinceEpoch);
  }

  Future<void> uploadSongs() async {
    final lastUploaded = await recentUploadTime;
    List<ListeningBehaviourModel> listeningBehaviour =
        await dbServiceA.getRecent(lastUploaded);
    List<Map<String, dynamic>> jsonModels = [];
    for (ListeningBehaviourModel behaviour in listeningBehaviour) {
      jsonModels.add(behaviour.toJson());
    }
    if (jsonModels.isNotEmpty) {
      DateTime now = DateTime.now().toUtc();
      String encodedBody = jsonEncode({"behaviour": jsonModels});
      http.Response resp = await http.post(Uri.parse("$baseUrl/add-songs"),
          headers: {
            "Authorization": "Bearer $jwt",
            "Content-Type": "application/json"
          },
          body: encodedBody);
      if (resp.statusCode < 400) {
        await setRecentUploadTime(now);
      } else {
        throw "Can't upload songs!";
      }
    }
  }
}

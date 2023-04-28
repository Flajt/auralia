import 'dart:convert';
import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:auralia/logic/abstract/NetworkingServiceA.dart';
import 'package:get_it/get_it.dart';
import "package:http/http.dart" as http;

class NetworkingService implements NetworkingServiceA {
  final _getIt = GetIt.I;

  @override
  Future<List<String>> getGenreRecommendation(
      {required double lat,
      required double long,
      required int activity,
      required int dateTimeInMis}) async {
    String authToken = await _getIt<AuthServiceA>().accessToken;
    final header = {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json"
    };
    //ORDER OF ELEMENTS: "dateTimeInMis","activity","latitude","logitude"
    Map<String, dynamic> bodyRaw = {
      "input": [dateTimeInMis, activity, lat, long]
    };
    String body = jsonEncode(bodyRaw);

    http.Response resp = await http.post(
        Uri.parse("https://auralia.fly.dev/predict"),
        body: body,
        headers: header);
    if (resp.statusCode < 300) {
      Map<String, dynamic> decodedBody = jsonDecode(resp.body);
      return List.from(decodedBody["prediction"]); //TODO: Find better way
    } else {
      throw resp.statusCode;
    }
  }
}

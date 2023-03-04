import 'package:isar/isar.dart';

part "ListeningBehaviourModel.g.dart";

@collection
class ListeningBehaviourModel {
  Id id = Isar.autoIncrement;
  final List<String> artists;
  final List<String> genres;
  final double latitude;
  final double longitude;
  final String activity;
  final int dateTimeInMis;

  ListeningBehaviourModel(this.artists, this.genres, this.latitude,
      this.longitude, this.activity, this.dateTimeInMis);
  Map<String, dynamic> toJson() => {
        "artists": artists,
        "genres": genres,
        "latitude": latitude,
        "logitude": longitude,
        "activity": activity,
        "dateTimeInMis": dateTimeInMis,
      };
  ListeningBehaviourModel.fromJson(Map<String, dynamic> json)
      : activity = json["activity"],
        artists = json["artists"],
        latitude = json["latitude"],
        longitude = json["longitude"],
        genres = json["genres"],
        dateTimeInMis = json["dateTImeInMs"];

  ListeningBehaviourModel copyWith({
    List<String>? artists,
    List<String>? genres,
    double? latitude,
    double? longitude,
    String? activity,
    int? dateTimeInMis,
  }) {
    return ListeningBehaviourModel(
        artists ?? this.artists,
        genres ?? this.genres,
        latitude ?? this.latitude,
        longitude ?? this.longitude,
        activity ?? this.activity,
        dateTimeInMis ?? this.dateTimeInMis);
  }
}

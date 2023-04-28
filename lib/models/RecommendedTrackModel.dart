class RecommendedTrackModel {
  final String name;
  final String id;
  final String albumType;
  final List<String> artists;
  final List<String> genres;
  const RecommendedTrackModel(
      this.name, this.id, this.albumType, this.artists, this.genres);

  RecommendedTrackModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        id = json["album"]["uri"],
        albumType = json["album"]["album_type"],
        artists = List.from(json["artists"].map((e) => e["id"])),
        genres = [];
  RecommendedTrackModel copywith(
      {String? name,
      String? id,
      String? album,
      String? albumType,
      List<String>? artists,
      List<String>? genres}) {
    return RecommendedTrackModel(
        name ?? this.name,
        id ?? this.id,
        albumType ?? this.albumType,
        artists ?? this.artists,
        genres ?? this.genres);
  }
}

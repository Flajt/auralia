abstract class PlayerStateModelA {
  final bool? isSong;
  final String id;
  final String songName;
  final List<String> artistIDs;
  final bool isPaused;
  final String? imageUri;

  PlayerStateModelA(
      {required this.imageUri,
      required this.id,
      required this.isSong,
      required this.songName,
      required this.artistIDs,
      required this.isPaused});
}

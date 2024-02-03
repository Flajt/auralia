import 'package:auralia/logic/abstract/models/PlayerStateModelA.dart';

class PlayerStateModel extends PlayerStateModelA {
  PlayerStateModel(
      {required bool isSong,
      required String id,
      required bool isPaused,
      required String songName,
      required String? imageUri,
      required List<String> artists})
      : super(
            isSong: isSong,
            id: id,
            isPaused: isPaused,
            songName: songName,
            imageUri: imageUri,
            artistIDs: artists);
}

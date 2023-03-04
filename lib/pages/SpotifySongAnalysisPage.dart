import 'package:auralia/logic/spotify-web/SpotifyWrapper.dart';
import 'package:auralia/logic/util/SpotifyUtil.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/regular/ListeningBehaviourModel.dart';

class SpotifySongAnalysis extends StatelessWidget {
  const SpotifySongAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            body: SizedBox.fromSize(
      size: size,
      child: Column(
        children: [
          OutlinedButton(
              onPressed: () async => await _getUserTrackHistory(),
              child: const Text("Analyse Songs"))
        ],
      ),
    )));
  }

  Future<void> _getUserTrackHistory() async {
    final String jwt =
        Supabase.instance.client.auth.currentSession?.providerToken ?? "";
    List<ListeningBehaviourModel> soundData = [];
    SpotifyWrapper wrapper = SpotifyWrapper(jwt);
    List userTracks = await wrapper.getRecentlyPlayedTracks();
    List<ListeningBehaviourModel> listeningBehaviour =
        await SpotifyUtil.extractArtistsAndGenres(jwt, userTracks);
    soundData.addAll(listeningBehaviour);
    for (int i = 50; i < 1000; i += 50) {
      int before = soundData.last.dateTimeInMis;
      List userTracks = await wrapper.getRecentlyPlayedTracks(null, before);
      List<ListeningBehaviourModel> listeningBehaviour =
          await SpotifyUtil.extractArtistsAndGenres(jwt, userTracks);
      soundData.addAll(listeningBehaviour);
    }
    print(soundData.length);
  }
}

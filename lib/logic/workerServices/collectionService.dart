import 'package:auralia/logic/spotify-web/SpotifyWrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import '../util/SpotifyUtil.dart';

class BackgroundServices {
  @pragma('vm:entry-point')
  static musicCollectionService() async {
    Workmanager().executeTask((taskName, inputData) async {
      String jwt = Supabase.instance.client.auth.currentSession!.providerToken!;
      final artistGerneMapping =
          await SpotifyUtil.getLatestUserArtistsAndGenres(jwt);
      return Future.value(true);
    });
  }

  @pragma('vm:entry-point')
  static locationActivityCollectionService() async {
    Workmanager().executeTask((taskName, inputData) {
      return Future.value(true);
    });
  }
}

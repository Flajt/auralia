import 'package:auralia/logic/services/BehaviourUploadService.dart';
import 'package:auralia/logic/services/DBService.dart';
import 'package:auralia/logic/util/initSuperbase.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
Future<void> behaviourBackgroundService() async {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final supabase = await initSupabase();
      final accessToken = supabase.client.auth.currentSession!.accessToken;
      final uploadService =
          BehaviourUploadService(dbServiceA: IsarDBService(), jwt: accessToken);
      await uploadService.uploadSongs();
      return Future.value(true);
    } catch (e) {
      Logger().e(e);
      return Future.error(e);
    }
  });
}

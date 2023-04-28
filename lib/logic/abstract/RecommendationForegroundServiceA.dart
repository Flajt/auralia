abstract class RecommendationForegroundServiceA {
  Future<void> init();
  Future<bool> isServiceRunning();
  Future<bool> startService(Function callBack);
  Future<bool> stopService();
  Future<bool> restartService();
  Future<bool> updateService(String? title, String? body);
}

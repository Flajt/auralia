abstract class PermissionServiceA {
  Future<bool> requestLocationAccess();
  Future<bool> reqeuestActivityRecognition();
  Future<bool> requestNotificationPermission();
  Future<bool> requestBackgroundLocationAccess();
  Future<bool> hasEnabledGPS();
}

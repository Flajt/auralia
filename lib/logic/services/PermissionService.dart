import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationAccess() async {
    PermissionStatus hasDefaultLocationPermission =
        await Permission.location.status;
    if (hasDefaultLocationPermission != PermissionStatus.granted) {
      hasDefaultLocationPermission = await Permission.location.request();
      if (hasDefaultLocationPermission != PermissionStatus.granted) {
        return false;
      }
      PermissionStatus hasBackgroundLocation =
          await Permission.locationAlways.status;
      if (hasBackgroundLocation != PermissionStatus.granted) {
        PermissionStatus status = await Permission.locationAlways.request();
        if (status != PermissionStatus.granted) {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> reqeuestActivityRecognition() async {
    PermissionStatus activityRecognitionEnabled =
        await Permission.activityRecognition.status;
    if (activityRecognitionEnabled != PermissionStatus.granted) {
      activityRecognitionEnabled =
          await Permission.activityRecognition.request();
      if (activityRecognitionEnabled != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<bool> requestNotificationPermission() async {
    Permission permission = Permission.notification;
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus != PermissionStatus.granted) {
      PermissionStatus reqStatus = await permission.request();
      if (reqStatus != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}

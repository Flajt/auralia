import 'package:auralia/uiblocks/dialogs/PermissionDialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final BuildContext context;
  PermissionService(this.context);

  Future<bool> requestLocationAccess() async {
    PermissionStatus hasDefaultLocationPermission =
        await Permission.location.status;
    if (hasDefaultLocationPermission != PermissionStatus.granted) {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => PermissionDialog(
              title: "Coarse Location",
              icon: Icons.pin_drop_outlined,
              description:
                  "This app uses approxmiate location data to recommend you music.",
              onPress: () async {
                await Permission.location.request();
                Navigator.of(context).pop();
              }));
      bool hasbasicPermission =
          (await Permission.location.status) == PermissionStatus.granted;
      if (!hasbasicPermission) {
        return false;
      } else {
        PermissionStatus hasBackgroundLocation =
            await Permission.locationAlways.status;
        if (hasBackgroundLocation != PermissionStatus.granted) {
          await showDialog(
              context: context,
              builder: (context) => PermissionDialog(
                  title: "Background Location",
                  icon: Icons.pin_drop_outlined,
                  description:
                      "This App uses the background location feature to allow us recommening you music while you are doing other things.",
                  onPress: () async {
                    await Permission.locationAlways.request();
                    Navigator.of(context).pop();
                  }));
          PermissionStatus status = await Permission.locationAlways.status;
          if (status != PermissionStatus.granted) {
            return false;
          }
          return true;
        }
      }
    }
    return true;
  }

  Future<bool> reqeuestActivityRecognition() async {
    PermissionStatus activityRecognitionEnabled =
        await Permission.activityRecognition.status;
    if (activityRecognitionEnabled != PermissionStatus.granted) {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => PermissionDialog(
              title: "Activity Recognition",
              icon: Icons.directions_walk,
              description:
                  "This App uses your current activity to recommend to you fitting music.",
              onPress: () async {
                await Permission.activityRecognition.request();
                Navigator.of(context).pop();
              }));
      if (activityRecognitionEnabled != PermissionStatus.granted) {
        return false;
      }
      return true;
    }
    return true;
  }

  Future<bool> requestNotificationPermission() async {
    Permission permission = Permission.notification;
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus != PermissionStatus.granted) {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => PermissionDialog(
              title: "Notifications",
              icon: Icons.notifications,
              description:
                  "To enable this App to run in the background and keep you up to date on what is happening it requires the ability to post notifications. If you have rejected it, open the settings to enable it.",
              onPress: () async {
                await Permission.notification.request();
                Navigator.of(context).pop();
              }));
      PermissionStatus reqStatus = await permission.status;
      if (reqStatus != PermissionStatus.granted) {
        return false;
      }
      return true;
    }
    return true;
  }

  Future<bool> hasEnabledGps() async {
    ServiceStatus status = await Permission.location.serviceStatus;
    return status == ServiceStatus.enabled;
  }
}

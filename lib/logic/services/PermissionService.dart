import 'dart:io';

import 'package:auralia/logic/abstract/PermissionServiceA.dart';
import 'package:auralia/uiblocks/dialogs/PermissionDialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService implements PermissionServiceA {
  final BuildContext context;
  PermissionService(this.context);

  @override
  Future<bool> requestLocationAccess() async {
    PermissionStatus hasDefaultLocationPermission =
        await Permission.locationWhenInUse.status;

    if (hasDefaultLocationPermission != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      bool? success = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => PermissionDialog(
              title: "Coarse Location",
              icon: Icons.pin_drop_outlined,
              description:
                  "This app uses approxmiate location data to recommend you music.",
              onPress: () async {
                PermissionStatus success =
                    await Permission.locationWhenInUse.request();
                Navigator.of(context).pop(success == PermissionStatus.granted);
              }));
      return success ?? false;
    }
    return true;
  }

  @override
  Future<bool> requestBackgroundLocationAccess() async {
    PermissionStatus hasBackgroundLocation =
        await Permission.locationAlways.status;
    if (hasBackgroundLocation != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      bool? success = await showDialog<bool>(
          context: context,
          builder: (context) => PermissionDialog(
              title: "Background Location",
              icon: Icons.pin_drop_outlined,
              description:
                  "This App uses the background location feature to allow us recommening you music while you are doing other things.",
              onPress: () async {
                PermissionStatus success =
                    await Permission.locationAlways.request();
                Navigator.of(context).pop(success == PermissionStatus.granted);
              }));
      return success ?? false;
    }
    return true;
  }

  @override
  Future<bool> reqeuestActivityRecognition() async {
    bool isAndroid = Platform.isAndroid;
    PermissionStatus activityRecognitionEnabled = isAndroid
        ? await Permission.activityRecognition.status
        : await Permission.sensors.status;

    if (activityRecognitionEnabled != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      bool? success = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => PermissionDialog(
              title: "Activity Recognition",
              icon: Icons.directions_walk,
              description:
                  "This App uses your current activity to recommend to you fitting music.",
              onPress: () async {
                PermissionStatus success = Platform.isAndroid
                    ? await Permission.activityRecognition.request()
                    : await Permission.sensors.request();
                Navigator.of(context).pop(success == PermissionStatus.granted);
              }));

      return success ?? false;
    }
    return true;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    Permission permission = Permission.notification;
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      bool? success = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => PermissionDialog(
              title: "Notifications",
              icon: Icons.notifications,
              description:
                  "To enable this App to run in the background and keep you up to date on what is happening it requires the ability to post notifications. If you have rejected it, open the settings to enable it.",
              onPress: () async {
                PermissionStatus success =
                    await Permission.notification.request();
                Navigator.of(context).pop(success == PermissionStatus.granted);
              }));
      return success ?? false;
    }
    return true;
  }

  @override
  Future<bool> hasEnabledGPS() async {
    ServiceStatus status = await Permission.locationAlways.serviceStatus;
    return status == ServiceStatus.enabled;
  }
}

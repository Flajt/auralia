import 'package:auralia/logic/abstract/CollectionForegroundServiceA.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class CollectionForegroundService implements CollectionForegroundServiceA {
  @override
  Future<bool> isServiceRunning() async {
    return await FlutterForegroundTask.isRunningService;
  }

  @override
  Future<bool> restartService() async {
    return await FlutterForegroundTask.restartService();
  }

  @override
  Future<bool> startService(Function callBack) async {
    return await FlutterForegroundTask.startService(
        notificationTitle: "Collection",
        notificationText: "Collecting your music taste",
        callback: callBack);
  }

  @override
  Future<bool> stopService() async {
    return await FlutterForegroundTask.stopService();
  }

  @override
  Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'auralia_collect_service_id',
          channelName: 'Collection',
          isSticky: true,
          channelDescription:
              'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          iconData: const NotificationIconData(
              resType: ResourceType.mipmap,
              resPrefix: ResourcePrefix.ic,
              name: "launcher",
              backgroundColor: Colors.white)),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  @override
  Future<bool> updateService(String? title, String? body) async {
    return await FlutterForegroundTask.updateService(
        notificationText: body, notificationTitle: title);
  }
}

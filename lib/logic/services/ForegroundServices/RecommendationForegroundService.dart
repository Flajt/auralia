import 'package:auralia/logic/abstract/RecommendationForegroundServiceA.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class RecommendationForegroundService
    implements RecommendationForegroundServiceA {
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
        notificationTitle: "Auralia",
        notificationText: "Recommending you music",
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
          channelId: 'auralia_collect_recommendation_id',
          channelName: 'Recommendation',
          isSticky: true,
          channelDescription: 'Recommedns you music',
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

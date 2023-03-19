import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../logic/services/OauthKeySerivce.dart';
import '../../../logic/services/PermissionService.dart';
import '../../../logic/services/SecureStorageWrapperService.dart';
import '../../../logic/util/tokenRefresh.dart';
import '../../../logic/workerServices/ForegroundService.dart';

class PersonalizationButton extends StatefulWidget {
  const PersonalizationButton({
    super.key,
    required this.permissionService,
  });

  final PermissionService permissionService;

  @override
  State<PersonalizationButton> createState() => _PersonalizationButtonState();
}

class _PersonalizationButtonState extends State<PersonalizationButton> {
  bool isRunning = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FlutterForegroundTask.isRunningService,
        builder: (context, snapshot) {
          isRunning = snapshot.data ?? false;
          return OutlinedButton(
            onPressed: () async {
              if (!isRunning) {
                List<bool> hasPermissions = await _hasAllPermissions();
                if (hasPermissions.any((element) => element == false) ==
                    false) {
                  bool locationServiceEnabled =
                      await widget.permissionService.hasEnabledGPS();
                  if (locationServiceEnabled == false) {
                    // ignore: use_build_context_synchronously
                    ElegantNotification.info(
                        description: Text(
                      "Please enable your GPS!",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )).show(context);
                  } else {
                    String jwt = Supabase
                        .instance.client.auth.currentSession!.accessToken;
                    await tokenRefresh(SpotifyOauthKeyService(
                        jwt: jwt,
                        storageWrapperService: SecureStorageWrapperService(),
                        baseUrl: "https://auralia.fly.dev"));
                    await FlutterForegroundTask.startService(
                        notificationTitle: "Collection",
                        notificationText: "Collecting your music taste",
                        callback: entryPoint);
                    setState(() {});
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  ElegantNotification.error(
                          description: const Text(
                              "All services are required, pelase try again"))
                      .show(context);
                }
              } else {
                await FlutterForegroundTask.stopService();
                setState(() {});
              }
            },
            style: isRunning
                ? OutlinedButton.styleFrom(foregroundColor: Colors.redAccent)
                : null,
            child: Text("${isRunning ? "Stop" : "Enable"} personalization"),
          );
        });
  }

  Future<List<bool>> _hasAllPermissions() async {
    bool activityEnabled =
        await widget.permissionService.reqeuestActivityRecognition();
    bool locationEnabled =
        await widget.permissionService.requestLocationAccess();
    bool backgroundLocationEnabled =
        await widget.permissionService.requestBackgroundLocationAccess();
    bool notificationEnabled =
        await widget.permissionService.requestNotificationPermission();
    return [
      activityEnabled,
      locationEnabled,
      backgroundLocationEnabled,
      notificationEnabled
    ];
  }
}

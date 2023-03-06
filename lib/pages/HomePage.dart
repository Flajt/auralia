import 'dart:async';
import 'package:auralia/logic/services/PermissionService.dart';
import 'package:auralia/logic/util/ForgroundServiceUtil.dart';
import 'package:auralia/logic/workerServices/ForegroundService.dart';
import 'package:auralia/uiblocks/buttons/SettingsButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initForeGroundService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WithForegroundTask(
      child: Scaffold(
        body: SafeArea(
            child: SizedBox.fromSize(
                size: size,
                child: Stack(children: [
                  const Align(
                      alignment: Alignment.topRight, child: SettingsButton()),
                  Center(
                      child: Text(
                          "This app currently only collects data, more features comming soon.",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: OutlinedButton(
                        onPressed: () async {
                          final PermissionService permissionService =
                              PermissionService();
                          bool activityEnabled = await permissionService
                              .reqeuestActivityRecognition();
                          bool locationEnabled =
                              await permissionService.requestLocationAccess();
                          bool notificationEnabled = await permissionService
                              .requestNotificationPermission();
                          if (activityEnabled &&
                              locationEnabled &&
                              notificationEnabled) {
                            await FlutterForegroundTask.startService(
                                notificationTitle: "Collection",
                                notificationText: "Collecting your music taste",
                                callback: entryPoint);
                          }
                        },
                        child: const Text("Enable personalization")),
                  )
                ]))),
      ),
    );
  }
}

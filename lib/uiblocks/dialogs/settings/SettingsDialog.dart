import 'dart:io';

import 'package:auralia/logic/services/BehaviourUploadService.dart';
import 'package:auralia/logic/services/DBService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String jwt = Supabase.instance.client.auth.currentSession!.accessToken;
    return Dialog(
      child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 400,
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Settings",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Platform.isIOS
                        ? ListTile(
                            title: const Text("Upload History"),
                            onTap: () async => await BehaviourUploadService(
                                    dbServiceA: IsarDBService(),
                                    jwt: jwt,
                                    baseUrl: "https://auarlia.fly.dev")
                                .uploadSongs(),
                          )
                        : const SizedBox(),
                    ListTile(
                        title: const Text("Logout"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Supabase.instance.client.auth.signOut();
                        }),
                    const IgnorePointer(
                      child: ListTile(
                        title: Text("Delete Account"),
                      ),
                    ),
                    ListTile(
                      title: const Text("Stop Personalization"),
                      onTap: () => FlutterForegroundTask.stopService(),
                    ),
                    const AboutListTile(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

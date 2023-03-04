import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 400,
          height: 400,
          child: ListView(
            children: [
              Center(
                  child: Text("Settings",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.bold))),
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
          )),
    );
  }
}

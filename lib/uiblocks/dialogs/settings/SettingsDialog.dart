import 'package:auralia/bloc/SettingsBloc/SettingsBlocEvent.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/SettingsBloc/SettingsBloc.dart';
import '../../../bloc/SettingsBloc/SettingsBlocState.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsBlocState>(
      listenWhen: (prev, cur) =>
          cur is ErrorUploadingBehaviour || cur is SuccessUploadingBehaviour
              ? true
              : false,
      listener: (context, state) {
        if (state is ErrorUploadingBehaviour) {
          ElegantNotification.error(
                  description: Text(state.errorMsg.toString()))
              .show(context);
        } else if (state is SuccessUploadingBehaviour) {
          ElegantNotification.success(
                  description: const Text("Data successfully uploaded"))
              .show(context);
        }
      },
      child: Dialog(
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
                      ListTile(
                        title: const Text("Listening Behaviour"),
                        onTap: () => Navigator.of(context)
                            .pushNamed("/listeningBehaviour"),
                      ),
                      ListTile(
                          title: const Text("Upload History"),
                          onTap: () => context
                              .read<SettingsBloc>()
                              .add(UploadBehaviour())),
                      ListTile(
                          title: const Text("Logout"),
                          onTap: () {
                            Navigator.of(context).pop();
                            context.read<SettingsBloc>().add(LogOut());
                          }),
                      const IgnorePointer(
                        child: ListTile(
                          title: Text("Delete Account"),
                        ),
                      ),
                      const AboutListTile(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

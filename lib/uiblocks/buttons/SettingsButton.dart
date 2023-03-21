import 'package:auralia/bloc/SettingsBloc/SettingsBloc.dart';
import 'package:auralia/uiblocks/dialogs/settings/SettingsDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icon.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => BlocProvider(
                  create: (context) => SettingsBloc(),
                  child: const SettingsDialog(),
                )),
        icon: LineIcon.cog());
  }
}

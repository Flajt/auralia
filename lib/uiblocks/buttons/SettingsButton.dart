import 'package:auralia/uiblocks/dialogs/settings/SettingsDialog.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog(
            context: context, builder: (context) => const SettingsDialog()),
        icon: LineIcon.cog());
  }
}

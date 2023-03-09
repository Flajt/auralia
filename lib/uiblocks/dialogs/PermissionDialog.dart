import 'package:flutter/material.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onPress;

  const PermissionDialog(
      {Key? key,
      required this.title,
      required this.icon,
      required this.description,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            width: 450,
            height: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(title, style: Theme.of(context).textTheme.headline4),
                Icon(icon, size: 40),
                Text(description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Reject")),
                    ElevatedButton(
                        onPressed: onPress, child: const Text("Enable"))
                  ],
                )
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:fz_hooks/fz_hooks.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? noActionText;
  final String? yesActionText;
  const AlertDialogWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.noActionText,
    this.yesActionText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: subTitle == null ? null : Text(subTitle!),
      actions: [
        TextButton(
          child: Text(noActionText ?? "No"),
          onPressed: () => context.pop(false),
        ),
        TextButton(
          child: Text(yesActionText ?? "Yes"),
          onPressed: () => context.pop(true),
        ),
      ],
    );
  }
}

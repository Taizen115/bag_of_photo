import 'package:flutter/material.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  String? content,
  required String okLabel,
  required String cancelLabel,
  required VoidCallback onOk,
  ButtonStyle? okStyle,
  ButtonStyle? cancelStyle,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(title, style: const TextStyle(fontSize: 22.0)),
      content: content != null
          ? Text(content, style: const TextStyle(fontSize: 20.0))
          : null,
      actions: [
        TextButton(
          style: cancelStyle,
          child: Text(cancelLabel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          style: okStyle,
          child: Text(okLabel),
          onPressed: () {
            Navigator.pop(context);
            onOk();
          },
        ),
      ],
    ),
  );
}
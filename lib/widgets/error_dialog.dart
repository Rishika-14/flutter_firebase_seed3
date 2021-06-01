import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String? content;

  ErrorDialog({
    this.title = 'Error',
    this.content,
  });

  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content ?? 'ErrorPlaceholder'),
      actions: [
        CupertinoDialogAction(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }



  AlertDialog _showMaterialDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content ?? 'ErrorPlaceholder'),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _showIOSDialog(context)
        : _showMaterialDialog(context);
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:cafe_365_app/src/core/consts/colors.dart';
import 'package:flutter/material.dart';

DiningConfirmationDialog(
  BuildContext context,
  String title,
  String msg,
  Function onConfirmed,
  Function onCancel,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop(false);
              onCancel();
            },
            child: const Text(
              'No',
              style: TextStyle(color: PRIMARY_COLOR),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirmed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: const Text(
              'Yes, continue',
              style: TextStyle(color: BG_COLOR),
            ),
          )
        ],
      );
    },
  );
}

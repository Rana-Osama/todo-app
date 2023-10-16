import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message,
      {bool isCancelable = true}) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text(message)
              ],
            ),
          );
        },
        barrierDismissible: isCancelable);
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {bool isCancelable = true,
      String? positiveActionTitle,
      String? negativeActionTitle,
      VoidCallback? positiveAction,
      VoidCallback? negativeAction}) {
    List<Widget> actions = [];

    if (positiveActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            positiveAction?.call();
          },
          child: Text(positiveActionTitle)));
    }
    if (negativeActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            negativeAction?.call();
          },
          child: Text(negativeActionTitle)));
    }
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            actions: actions,
            content: Expanded(child: Text(message)),
          );
        },
        barrierDismissible: isCancelable);
  }
}

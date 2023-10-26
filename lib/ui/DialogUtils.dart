import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message,
      {bool isCancelable = true}) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
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
          child: Text(positiveActionTitle,
              style: Theme.of(context).textTheme.bodyMedium)));
    }
    if (negativeActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            negativeAction?.call();
          },
          child: Text(negativeActionTitle,
              style: Theme.of(context).textTheme.bodyMedium)));
    }
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            actions: actions,
            content: Expanded(
                child: Text(message,
                    style: Theme.of(context).textTheme.bodyMedium)),
          );
        },
        barrierDismissible: isCancelable);
  }
}

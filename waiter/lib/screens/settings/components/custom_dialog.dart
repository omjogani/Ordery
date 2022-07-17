import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waiter/screens/settings/full_screen_dialog.dart';

class CustomShowDialog {
  void showFullScreenDialog(BuildContext context, bool isHeighted,
      double height, double width, Widget child) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: FullScreenDialog(
              isHeighted: isHeighted,
              height: height,
              width: width,
              child: child,
            ),
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return Text("Diploma Mentor");
      },
    );
  }

  void showCustomDialog(
      BuildContext context, String content, String buttonText) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 23.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 23.0,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
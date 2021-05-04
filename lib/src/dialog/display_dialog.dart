import 'package:flutter/material.dart';

import 'package:tfg_app/src/dialog/error_dialog.dart';

class DisplayDialog {
  static displayErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (e) {
        return ErrorAlertDialog(message: message);
      },
    );
  }
}

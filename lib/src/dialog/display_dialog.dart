import 'package:flutter/material.dart';

import 'package:tfg_app/src/dialog/error_dialog.dart';
import 'package:tfg_app/src/dialog/available_dialog.dart';

class DisplayDialog {
  static displayErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (e) {
        return ErrorAlertDialog(message: message);
      },
    );
  }

  static displayAvailableDialog(BuildContext context, String message, String id, bool available) {
    showDialog(
      context: context,
      builder: (e) {
        return AvailableAlertDialog(message: message, id: id, available: available);
      },
    );
  }
}

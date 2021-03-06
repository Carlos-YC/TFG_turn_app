import 'package:flutter/material.dart';
import 'package:tfg_app/src/controllers/product_controller.dart';

class AvailableAlertDialog extends StatelessWidget {
  final String message;
  final bool available;
  final String id;

  const AvailableAlertDialog({Key key, this.message, this.id, this.available}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
          child: Center(
            child: Text("Sí"),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: () {
            ListProductController().updateAvailable(id, available);
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Center(
            child: Text("No"),
          ),
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

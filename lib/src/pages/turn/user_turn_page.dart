import 'package:flutter/material.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class UserTurnPage extends StatefulWidget {
  @override
  _UserTurnPageState createState() => _UserTurnPageState();
}

class _UserTurnPageState extends State<UserTurnPage> {
  List users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomBoxDecoration(
          color1: Colors.lightGreen,
          color2: Colors.green,
        ),
        title: Text(
          'Mi turno',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
      body: _productsTable(context),
    );
  }

  Widget _productsTable(BuildContext context) {
    return Container();
  }
}

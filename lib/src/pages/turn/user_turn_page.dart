import 'package:flutter/material.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';

class UserTurnPage extends StatefulWidget {
  @override
  _UserTurnPageState createState() => _UserTurnPageState();
}

class _UserTurnPageState extends State<UserTurnPage> {
  List users;
  final dbRef = TurnProvider().hasTurn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.green],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'Turno',
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

import 'package:flutter/material.dart';

class UserTurnPage extends StatefulWidget {
  @override
  _UserTurnPageState createState() => _UserTurnPageState();
}

class _UserTurnPageState extends State<UserTurnPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Para que sea adaptativo
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
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
        body: _productsTable(context, size),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _productsTable(BuildContext context, Size size) {
    return Container();
  }
}

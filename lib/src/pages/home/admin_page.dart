import 'package:flutter/material.dart';

import 'package:tfg_app/src/providers/user_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomBoxDecoration(
          color1: Colors.lightBlueAccent,
          color2: Colors.blue,
        ),
        title:
            Text('Sesión de administrador', style: TextStyle(color: Colors.white, fontSize: 24.0)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => UserProvider().logOut(context),
          )
        ],
      ),
      body: _adminScreen(context),
    );
  }

  Widget _adminScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.greenAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_turns(context), _products(context)],
        ),
      ),
    );
  }

  Widget _turns(BuildContext context) {
    String _text = 'Ver turnos';
    String _route = 'adminTurn';

    return _boxButton(context, _text, _route);
  }

  Widget _products(BuildContext context) {
    String _text = 'Productos';
    String _route = 'listProducts';

    return _boxButton(context, _text, _route);
  }

  Widget _boxButton(BuildContext context, String text, String route) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Color(0xFF00d2e4),
              borderRadius: BorderRadius.circular(7.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.5, 1.5),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Center(
              child: _textShow(text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textShow(String text) {
    return FittedBox(
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48.0, color: Color(0xFF3f4756)),
      ),
    );
  }
}

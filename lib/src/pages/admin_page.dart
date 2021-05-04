import 'package:flutter/material.dart';
import 'package:tfg_app/src/providers/user_provider.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text('Sesión de administrador',
              style: TextStyle(color: Colors.white, fontSize: 24.0)),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => UserProvider().logOut(context),
            )
          ],
        ),
        body: _adminScreen(context, size),
      ),
    );
  }

  Widget _adminScreen(BuildContext context, Size size) {
    return Container(
      width: size.width * 1,
      height: size.height * 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.greenAccent],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
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
    String _text = 'Pedidos';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_textShow(text)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textShow(String text) {
    return FittedBox(
        child: Text(text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 48.0, color: Color(0xFF3f4756))));
  }
}

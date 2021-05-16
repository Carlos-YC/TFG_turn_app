import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';
import 'package:tfg_app/src/providers/user_provider.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SupermarketApp.sharedPreferences.getString(SupermarketApp.userEmail),
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => UserProvider().logOut(context),
          )
        ],
      ),
      body: _userScreen(context),
    );
  }

  Widget _userScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_takeTurn(context), _products(context)],
        ),
      ),
    );
  }

  Widget _takeTurn(BuildContext context) {
    return FutureBuilder(
      future: TurnProvider().hasTurn(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print('Error');
        if (!snapshot.hasData) return CircularProgressIndicator();
        bool hasTurn = snapshot.data;
        String _text;
        String _route = 'userTurn';
        if (!hasTurn) {
          _text = 'Pedir turno';
          _route = '';
        } else {
          _text = 'Ver turno';
        }
        return _boxButton(context, _text, _route);
      },
    );
  }

  Widget _products(BuildContext context) {
    String _text = 'Ver productos';
    String _route = 'products';

    return _boxButton(context, _text, _route);
  }

  Widget _boxButton(BuildContext context, String text, String route) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () =>
              (route == '') ? _readQR(context, 'userTurn') : Navigator.pushNamed(context, route),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFF97f48a),
              borderRadius: BorderRadius.circular(7.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.5, 1.5),
                  spreadRadius: 3.0,
                )
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
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: Color(0xFF3f4756)),
      maxLines: 1,
    );
  }

  Future<void> _readQR(BuildContext context, String route) async {
    bool _isScanDB = await TurnProvider().readQR();
    if (_isScanDB) {
      Navigator.pushNamed(context, route);
    }
  }
}

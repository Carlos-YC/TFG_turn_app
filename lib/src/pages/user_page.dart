import 'package:flutter/material.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/user_provider.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }

  Widget _userScreen(BuildContext context) {
    return Text('hola');
  }
}

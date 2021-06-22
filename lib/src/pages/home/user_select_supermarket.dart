import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/select_supermarket_provider.dart';

import 'package:tfg_app/src/providers/user_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class UserSelectSupermarket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomBoxDecoration(
          color1: Colors.lightGreen,
          color2: Colors.green,
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
      body: Center(child: _userScreen()),
    );
  }

  Widget _userScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_selectSupermarket()],
      ),
    );
  }

  Widget _selectSupermarket() {
    return InkWell(
      onTap: () => _readQR('userTurn'),
      child: Container(
        height: 180,
        width: 320,
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
          child: _textShow('Escanear QR supermercado'),
        ),
      ),
    );
  }

  Widget _textShow(String text) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF3f4756)),
      maxLines: 2,
    );
  }

  Future<void> _readQR(String route) async {
    bool _isScanDB = await SupermarketProvider().readQRSupermarket();
    (_isScanDB) ? Get.offAllNamed('userPage') : print('¡QR no valido!');
  }
}

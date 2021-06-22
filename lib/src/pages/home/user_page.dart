import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:tfg_app/src/config/config.dart';

import 'package:tfg_app/src/controllers/turn/user_has_turn_controller.dart';
import 'package:tfg_app/src/providers/select_supermarket_provider.dart';
import 'package:tfg_app/src/providers/user_provider.dart';

import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class UserPage extends StatelessWidget {
  final bool hasTurn = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserHasTurnController>(
      init: UserHasTurnController(),
      builder: (controller) => Scaffold(
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
        body: _userScreen(controller),
      ),
    );
  }

  Widget _userScreen(UserHasTurnController controller) {
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
          children: [_takeTurn(controller), _products(), _buttonOut()],
        ),
      ),
    );
  }

  Widget _takeTurn(UserHasTurnController controller) {
    return Obx(() {
      if (controller.hasTurn.value) {
        return _boxButton('Ver turno', 'userTurn');
      } else {
        return _boxButton('Pedir turno', 'selectServiceTurn');
      }
    });
  }

  Widget _products() {
    String _text = 'Ver productos';
    String _route = 'selectService';

    return _boxButton(_text, _route);
  }

  Widget _boxButton(String text, String route) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () => Get.toNamed(route),
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
              child: _textShow(text, 0xFF3f4756),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textShow(String text, int color) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: Color(color)),
      maxLines: 1,
    );
  }

  Widget _buttonOut() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: InkWell(
        onTap: () => _supermarketOut(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Center(
            child: _textShow('Salir del supermercado', 0xFFFFFFFF),
          ),
        ),
      ),
    );
  }

  Future<void> _supermarketOut() async {
    await SupermarketProvider().logoutSupermarket();
    Get.offAllNamed('selectSupermarket');
  }
}

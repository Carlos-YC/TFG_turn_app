import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/controllers/turn_controller.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';
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
          children: [_takeTurn(controller), _products()],
        ),
      ),
    );
  }

  Widget _takeTurn(UserHasTurnController controller) {
    return Obx(() {
      if (controller.hasTurn.value) {
        return _boxButton('Ver turno', 'userTurn');
      } else {
        return _boxButton('Pedir turno', '');
      }
    });
  }

  Widget _products() {
    String _text = 'Ver productos';
    String _route = 'products';

    return _boxButton(_text, _route);
  }

  Widget _boxButton(String text, String route) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () => (route == '') ? _readQR('userTurn') : Get.toNamed(route),
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

  Future<void> _readQR(String route) async {
    bool _isScanDB = await TurnProvider().readQR();
    (_isScanDB) ? Get.toNamed(route) : print('¡QR no valido!');
  }
}

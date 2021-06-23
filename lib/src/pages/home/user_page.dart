import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:tfg_app/src/config/config.dart';

import 'package:tfg_app/src/controllers/turn/user_has_turn_controller.dart';
import 'package:tfg_app/src/providers/select_supermarket_provider.dart';
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
        body: _userScreen(context, controller),
      ),
    );
  }

  Widget _userScreen(BuildContext context, UserHasTurnController controller) {
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
          children: [
            _takeTurn(controller),
            _products(),
            SizedBox(height: 20),
            _buttonOut(context),
          ],
        ),
      ),
    );
  }

  Widget _takeTurn(UserHasTurnController controller) {
    return Obx(() {
      if (controller.hasTurn1.value) {
        return _boxButton('Ver turno', 'userTurn');
      } else if (controller.hasTurn2.value) {
        return _boxButton('Ver turno', 'userTurn');
      } else if (controller.hasTurn3.value) {
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
      child: InkWell(
        onTap: () => Get.toNamed(route),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
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

  Widget _buttonOut(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45),
      child: ElevatedButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('¿Seguro que desea salir?'),
            content: Text('Si sale perderá todos los turnos en los que esté.'),
            actions: [
              TextButton(
                onPressed: () {
                  TurnProvider().cancelTurn('charcuteria');
                  _supermarketOut();
                },
                child: Text('Confirmar'),
                style: TextButton.styleFrom(primary: Colors.green),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancelar'),
                child: Text('Cancelar'),
                style: TextButton.styleFrom(primary: Colors.red),
              )
            ],
          ),
        ),
        child: Container(
          child: Text(
            'Salir del supermercado',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          elevation: 2.0,
          primary: Colors.red,
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _supermarketOut() async {
    await SupermarketProvider().logoutSupermarket();
    Get.offAllNamed('selectSupermarket');
  }
}

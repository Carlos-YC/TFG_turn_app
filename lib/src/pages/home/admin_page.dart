import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:tfg_app/src/controllers/turn/admin_send_notification_controller.dart';
import 'package:tfg_app/src/providers/select_supermarket_provider.dart';
import 'package:tfg_app/src/providers/user_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminSendNotificationController>(
      init: AdminSendNotificationController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: CustomBoxDecoration(
            color1: Colors.lightBlueAccent,
            color2: Colors.blue,
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
        body: _adminScreen(),
      ),
    );
  }

  Widget _adminScreen() {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            _supermarketInfo(),
            SizedBox(height: 30),
            _turns(),
            _products(),
          ],
        ),
      ),
    );
  }

  Widget _supermarketInfo() {
    return FutureBuilder(
      future: SupermarketProvider().supermarketInfo(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Error al cargar nombre');
        } else {
          return Column(
            children: [
              _textInfo(snapshot.data[0], 36.0, 1.5),
              SizedBox(width: 50, child: Divider(color: Colors.white, thickness: 2)),
              _textInfo(snapshot.data[1], 18.0, 0.5),
            ],
          );
        }
      },
    );
  }

  Widget _textInfo(String text, double size, double spacing) {
    return Text(
      text,
      style: TextStyle(
        letterSpacing: spacing,
        color: Colors.white,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _turns() {
    String _text = 'Ver turnos';
    String _route = 'adminTurn';

    return _boxButton(_text, _route);
  }

  Widget _products() {
    String _text = 'Productos';
    String _route = 'listProducts';

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
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: Color(0xFF3f4756)),
      maxLines: 1,
    );
  }
}

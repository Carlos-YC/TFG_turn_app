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
            'Turn App',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
        endDrawer: Container(width: 250, child: Drawer(child: _drawer(context))),
        body: _userScreen(context, controller),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Container(
      color: Colors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),
          _drawerItem(
            icon: Icons.person,
            text:
                'Usuario: ${SupermarketApp.sharedPreferences.getString(SupermarketApp.userEmail)}',
            onTap: () {},
          ),
          _drawerItem(
            icon: Icons.remove_shopping_cart,
            text: 'Salir del supermercado',
            onTap: () => _supermarketOut(),
          ),
          Divider(thickness: 5),
          _drawerItem(
            icon: Icons.logout,
            text: 'Cerrar sesión',
            onTap: () => UserProvider().logOut(context),
          )
        ],
      ),
    );
  }

  Widget _drawerHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image:
            DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/image_drawer.png')),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: Text(
              "Turn App",
              style: TextStyle(color: Colors.white, fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            _supermarketInfo(),
            SizedBox(height: 30),
            _takeTurn(controller),
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
    String _route = 'products';

    return _boxButton(_text, _route);
  }

  Widget _boxButton(String text, String route) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
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

  Future<void> _supermarketOut() async {
    await TurnProvider().cancelTurn('carniceria');
    await TurnProvider().cancelTurn('charcuteria');
    await TurnProvider().cancelTurn('pescaderia');
    await SupermarketProvider().logoutSupermarket();
    Get.offAllNamed('selectSupermarket');
  }
}

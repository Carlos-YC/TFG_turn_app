import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/providers/select_supermarket_provider.dart';

import 'package:tfg_app/src/providers/user_provider.dart';

class UserSelectSupermarket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(right: 5, left: 5, bottom: 5),
            child: Stack(
              children: [
                Positioned(
                  child: Align(
                    alignment: FractionalOffset.topRight,
                    child: ElevatedButton.icon(
                      label: Text('Cerrar sesión', style: TextStyle(fontSize: 16)),
                      icon: Icon(Icons.logout, size: 16),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () => UserProvider().logOut(context),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Image.asset('assets/icons/icon2.png'),
                    onTap: () => _readQR('userTurn'),
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        'Pulsar el ticket para \n escanear el QR',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _readQR(String route) async {
    bool _isScanDB = await SupermarketProvider().readQRSupermarket();
    (_isScanDB) ? Get.offAllNamed('userPage') : print('¡QR no valido!');
  }
}

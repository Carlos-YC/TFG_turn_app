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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/icons/icon2.png', width: 350, height: 400),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  label: Text(
                    'Escanear el supermercado \n en el que te encuentras',
                    style: TextStyle(fontSize: 16),
                  ),
                  icon: Icon(Icons.qr_code, size: 42),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () => _readQR('userTurn'),
                ),
              ],
            ),
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
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
          ],
        ),
      ),
    );
  }

  Future<void> _readQR(String route) async {
    bool _isScanDB = await SupermarketProvider().readQRSupermarket();
    (_isScanDB) ? Get.offAllNamed('userPage') : print('¡QR no valido!');
  }
}

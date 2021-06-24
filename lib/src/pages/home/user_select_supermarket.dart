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
                  child: Image.asset('assets/icons/icon1.png', width: 200, height: 300),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: CircleBorder()),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(Icons.qr_code, size: 42),
                  ),
                  onPressed: () => _readQR('userTurn'),
                ),
              ],
            ),
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Cerrar sesión', style: TextStyle(fontSize: 16)),
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

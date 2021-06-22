import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/user_provider.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  String supermarketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);

  @override
  void initState() {
    super.initState();

    displayInit();
  }

  displayInit() {
    Timer(Duration(seconds: 5), () async {
      if (SupermarketApp.auth.currentUser == null) {
        Get.offAllNamed('authentication');
      } else {
        bool isAdmin = await UserProvider().isAdminLogged();
        if(isAdmin) {
          Get.offAllNamed('adminPage');
        } else {
          if(supermarketId != 'marketid' && supermarketId != null) {
            Get.offAllNamed('userPage');
          } else {
            Get.offAllNamed('selectSupermarket');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/init_img.png'),
              SizedBox(height: 20.0),
              Text('Turn app', style: TextStyle(color: Colors.white, fontSize: 28.0))
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:tfg_app/src/config/config.dart';

import 'package:tfg_app/src/pages/init_page.dart';
import 'package:tfg_app/src/pages/authentication/select_authentication_page.dart';
import 'package:tfg_app/src/pages/authentication/register_page.dart';
import 'package:tfg_app/src/pages/authentication/login_page.dart';

import 'package:tfg_app/src/pages/home/admin_page.dart';
import 'package:tfg_app/src/pages/home/user_page.dart';

import 'package:tfg_app/src/pages/products/list_products_page.dart';
import 'package:tfg_app/src/pages/products/cart_products_page.dart';
import 'package:tfg_app/src/pages/products/detail_product_page.dart';

import 'package:tfg_app/src/pages/turn/user_turn_page.dart';
import 'package:tfg_app/src/pages/turn/admin_turn_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SupermarketApp.auth = FirebaseAuth.instance;
  SupermarketApp.sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: SupermarketApp.appName,
        home: InitPage(),
        routes: {
          'authentication': (BuildContext context) => SelectAuthenticationPage(),
          'register': (BuildContext context) => RegisterPage(),
          'login': (BuildContext context) => LoginPage(),
          'adminPage': (BuildContext context) => AdminPage(),
          'userPage': (BuildContext context) => UserPage(),
          'userTurn': (BuildContext context) => UserTurnPage(),
          'adminTurn': (BuildContext context) => AdminTurnPage(),
          'products': (BuildContext context) => ProductsPage(),
          'listProducts': (BuildContext context) => ListProductsPage(),
          'productDetails': (BuildContext context) => ProductDetails()
        },
        theme: ThemeData(
            primaryColor: Colors.green, visualDensity: VisualDensity.adaptivePlatformDensity));
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';
import 'package:tfg_app/src/config/config.dart';

import 'package:tfg_app/src/pages/init_page.dart';
import 'package:tfg_app/src/pages/authentication/select_authentication_page.dart';
import 'package:tfg_app/src/pages/authentication/register_page.dart';
import 'package:tfg_app/src/pages/authentication/login_page.dart';

import 'package:tfg_app/src/pages/home/admin_page.dart';
import 'package:tfg_app/src/pages/home/user_select_supermarket.dart';
import 'package:tfg_app/src/pages/home/user_page.dart';

import 'package:tfg_app/src/pages/products/list_products_page.dart';
import 'package:tfg_app/src/pages/products/select_supermarket_service_page.dart';
import 'package:tfg_app/src/pages/products/card_products_page.dart';
import 'package:tfg_app/src/pages/products/detail_product_page.dart';

import 'package:tfg_app/src/pages/turn/select_service_turn_page.dart';
import 'package:tfg_app/src/pages/turn/user_turn_page.dart';
import 'package:tfg_app/src/pages/turn/admin_turn_page.dart';
import 'package:tfg_app/src/providers/push_notification_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SupermarketApp.auth = FirebaseAuth.instance;
  SupermarketApp.sharedPreferences = await SharedPreferences.getInstance();
  await PushNotificationProvider.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    PushNotificationProvider.messagesStream.listen((message) {
      navigatorKey.currentState.pushNamed('userTurn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: SupermarketApp.appName,
      navigatorKey: navigatorKey,
      home: InitPage(),
      routes: {
        'authentication': (BuildContext context) => SelectAuthenticationPage(),
        'register': (BuildContext context) => RegisterPage(),
        'login': (BuildContext context) => LoginPage(),
        'adminPage': (BuildContext context) => AdminPage(),
        'selectSupermarket': (BuildContext context) => UserSelectSupermarket(),
        'userPage': (BuildContext context) => UserPage(),
        'selectServiceTurn': (BuildContext context) => SelectServiceTurnPage(),
        'userTurn': (BuildContext context) => UserTurnPage(),
        'adminTurn': (BuildContext context) => AdminTurnPage(),
        'selectService': (BuildContext context) => SelectSupermarketServicePage(),
        'products': (BuildContext context) => ProductsPage(),
        'listProducts': (BuildContext context) => ListProductsPage(),
        'detailsProduct': (BuildContext context) => ProductDetails(),
      },
      theme: ThemeData(
          primaryColor: Colors.green, visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}

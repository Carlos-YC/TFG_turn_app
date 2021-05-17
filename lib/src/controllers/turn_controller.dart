import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';

class TurnUserController extends GetxController {
  final String _uid = SupermarketApp.sharedPreferences.getString(SupermarketApp.userUID);
  final _turnRealTimeDB = FirebaseDatabase.instance
      .reference()
      .child('codigo_supermercado')
      .child('cola_espera')
      .child('charcuteria');

  StreamSubscription<Event> listener;
  RxBool hasTurn = RxBool(false);

  @override
  void onReady() {
    this.hasTurnRealTimeDB();
    super.onReady();
  }

  @override
  void onClose() {
    this.listener.cancel();
    super.onClose();
  }

  void hasTurnRealTimeDB() {
    var _userLogger = _turnRealTimeDB.orderByChild('id_usuario').equalTo(_uid);
    this.listener = _userLogger.onValue.listen((event) {
      if (event.snapshot.value != null) {
        this.hasTurn.value = true;
      } else {
        this.hasTurn.value = false;
      }
    });
  }
}

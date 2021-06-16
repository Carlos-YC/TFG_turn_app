import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';

class UserHasTurnController extends GetxController {
  final _turnRealTimeDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> listener;
  RxBool hasTurn = RxBool(false);

  String _uid;
  String _marketId;

  UserHasTurnController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._uid = SupermarketApp.auth.currentUser.uid;
  }

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
    var _userLogged = _turnRealTimeDB
        .child('A1ktePQNfo')
        .child('cola_espera')
        .child('charcuteria')
        .orderByChild('id_usuario')
        .equalTo(_uid);
    this.listener = _userLogged.onValue.listen((event) {
      (event.snapshot.value != null) ? this.hasTurn.value = true : this.hasTurn.value = false;
    });
  }
}

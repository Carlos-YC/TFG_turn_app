import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';

class UserHasTurnController extends GetxController {
  final _turnRealTimeDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> listener1, listener2, listener3;
  RxBool hasTurn1 = RxBool(false);
  RxBool hasTurn2 = RxBool(false);
  RxBool hasTurn3 = RxBool(false);

  String _uid;
  String _marketId;

  UserHasTurnController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._uid = SupermarketApp.auth.currentUser.uid;
  }

  @override
  void onReady() {
    this.hasTurnRealTimeDB1();
    this.hasTurnRealTimeDB2();
    this.hasTurnRealTimeDB3();
    super.onReady();
  }

  @override
  void onClose() {
    this.listener1.cancel();
    this.listener2.cancel();
    this.listener3.cancel();
    super.onClose();
  }

  void hasTurnRealTimeDB1() {
    var _userLogged = _turnRealTimeDB.child(_marketId).child('cola_espera').child('carniceria');
    this.listener1 = _userLogged.orderByChild('id_usuario').equalTo(_uid).onValue.listen((event) {
      (event.snapshot.value != null) ? this.hasTurn1.value = true : this.hasTurn1.value = false;
    });
  }

  void hasTurnRealTimeDB2() {
    var _userLogged = _turnRealTimeDB.child(_marketId).child('cola_espera').child('charcuteria');
    this.listener2 = _userLogged.orderByChild('id_usuario').equalTo(_uid).onValue.listen((event) {
      (event.snapshot.value != null) ? this.hasTurn2.value = true : this.hasTurn2.value = false;
    });
  }

  void hasTurnRealTimeDB3() {
    var _userLogged = _turnRealTimeDB.child(_marketId).child('cola_espera').child('pescaderia');
    this.listener3 = _userLogged.orderByChild('id_usuario').equalTo(_uid).onValue.listen((event) {
      (event.snapshot.value != null) ? this.hasTurn3.value = true : this.hasTurn3.value = false;
    });
  }
}

import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';

final _turnRealTimeDB = FirebaseDatabase.instance
    .reference()
    .child('codigo_supermercado')
    .child('cola_espera')
    .child('charcuteria');
final String _uid = SupermarketApp.auth.currentUser.uid;

class UserHasTurnController extends GetxController {
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
    var _userLogged = _turnRealTimeDB.orderByChild('id_usuario').equalTo(_uid);
    this.listener = _userLogged.onValue.listen((event) {
      if (event.snapshot.value != null) {
        this.hasTurn.value = true;
      } else {
        this.hasTurn.value = false;
      }
    });
  }
}

class TurnUserInfoController extends GetxController {
  StreamSubscription<Event> listener;
  List turnUserInfo = [];
  RxInt numUsers = RxInt(0);
  RxInt firstUserNumber = RxInt(0);

  @override
  void onReady() {
    this.firstUserInfoRealTimeDB();
    super.onReady();
  }

  @override
  void onClose() {
    this.listener.cancel();
    super.onClose();
  }

  void firstUserInfoRealTimeDB() {
    var _firstUserInfo = _turnRealTimeDB.orderByKey().limitToFirst(1);
    this.listener = _firstUserInfo.onValue.listen((event) async {
      final _firstUserData = event.snapshot.value;
      if (_firstUserData != null) {
        turnUserInfo = await TurnProvider().getUserTurnInfo();
        _firstUserData.forEach((key, value) {
          this.firstUserNumber.value = value['num'];
          this.numUsers.value = turnUserInfo[0]['num'] - this.firstUserNumber.value;
        });
      }
    });
  }
}

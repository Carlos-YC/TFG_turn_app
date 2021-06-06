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

class UserHasTurnController extends GetxController {
  final String _uid = SupermarketApp.auth.currentUser.uid;
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

class AdminTurnController extends GetxController {
  StreamSubscription<Event> firstUser;
  StreamSubscription<Event> lastUser;
  RxInt allUsers = RxInt(null);
  RxInt userNumber = RxInt(null);
  RxInt firstUserNumber = RxInt(0);
  RxInt lastUserNumber = RxInt(0);

  @override
  void onReady() {
    this.firstUserInfoRealTimeDB();
    this.lastUserInfoRealTimeDB();
    super.onReady();
  }

  @override
  void onClose() {
    this.firstUser.cancel();
    this.lastUser.cancel();
    super.onClose();
  }

  void firstUserInfoRealTimeDB() {
    var _firstUserInfo = _turnRealTimeDB.orderByKey().limitToFirst(1);
    this.firstUser = _firstUserInfo.onValue.listen((event) {
      final _firstUserData = event.snapshot.value;
      if (_firstUserData != null) {
        _firstUserData.forEach((key, value) {
          this.firstUserNumber.value = value['num'];
          this.userNumber.value = value['tu_num'];
        });
        numberClientsRealTime();
      } else {
        this.userNumber.value = 0;
      }
    });
  }

  void lastUserInfoRealTimeDB() {
    var _lastUserInfo = _turnRealTimeDB.orderByKey().limitToLast(1);
    this.lastUser = _lastUserInfo.onValue.listen((event) {
      final _lastUserData = event.snapshot.value;
      if (_lastUserData != null) {
        _lastUserData.forEach((key, value) {
          this.lastUserNumber.value = value['num'];
        });
        numberClientsRealTime();
      }
    });
  }

  void numberClientsRealTime() {
    if (firstUserNumber.value > 0 && lastUserNumber.value > 0) {
      this.allUsers.value = this.lastUserNumber.value - this.firstUserNumber.value;
    }
  }
}

import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';

class AdminTurnController extends GetxController {
  final _turnRealTimeDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> firstUser;
  StreamSubscription<Event> lastUser;
  RxInt allUsers = RxInt(null);
  RxInt userNumber = RxInt(null);
  RxInt firstUserNumber = RxInt(0);
  RxInt lastUserNumber = RxInt(0);

  String _marketId;
  String _adminService;

  AdminTurnController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._adminService = SupermarketApp.sharedPreferences.getString(SupermarketApp.service);
  }

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
    var _firstUserInfo = _turnRealTimeDB
        .child(_marketId)
        .child('cola_espera')
        .child(_adminService)
        .orderByKey()
        .limitToFirst(1);
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
    var _lastUserInfo = _turnRealTimeDB
        .child(_marketId)
        .child('cola_espera')
        .child(_adminService)
        .orderByKey()
        .limitToLast(1);
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
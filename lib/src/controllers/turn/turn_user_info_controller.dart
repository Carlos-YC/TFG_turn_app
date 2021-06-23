import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';

class TurnUserInfoController extends GetxController {
  final _turnRealTimeDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> listener;
  List turnUserInfo = [];
  RxInt numUsers = RxInt(0);
  RxInt firstUserNumber = RxInt(0);

  String _marketId;

  TurnUserInfoController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
  }

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
    if (_marketId != 'marketid' || _marketId != null) {
      var _firstUserInfo = _turnRealTimeDB
          .child(_marketId)
          .child('cola_espera')
          .child('charcuteria')
          .orderByKey()
          .limitToFirst(1);
      this.listener = _firstUserInfo.onValue.listen((event) async {
        final _firstUserData = event.snapshot.value;
        if (_firstUserData != null) {
          turnUserInfo = await TurnProvider().getUserTurnInfo('charcuteria');
          _firstUserData.forEach((key, value) {
            this.firstUserNumber.value = value['num'];
            this.numUsers.value = turnUserInfo[0]['num'] - this.firstUserNumber.value;
          });
        }
      });
      print('No tiene supermercado');
    }
  }
}

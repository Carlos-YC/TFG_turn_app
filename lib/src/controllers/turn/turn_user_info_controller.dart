import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';

class TurnUserInfoController extends GetxController {
  final _turnRealTimeDB = FirebaseDatabase.instance.reference();

  StreamSubscription<Event> listenerCarniceria;
  StreamSubscription<Event> listenerCharcuteria;
  StreamSubscription<Event> listenerPescaderia;

  List turnUserInfoCarniceria = [];
  List turnUserInfoCharcuteria = [];
  List turnUserInfoPescaderia = [];

  RxInt numUsersCarniceria = RxInt(0);
  RxInt numUsersCharcuteria = RxInt(0);
  RxInt numUsersPescaderia = RxInt(0);

  RxInt firstUserNumberCarniceria = RxInt(0);
  RxInt firstUserNumberCharcuteria = RxInt(0);
  RxInt firstUserNumberPescaderia = RxInt(0);

  String _marketId;

  TurnUserInfoController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
  }

  @override
  void onReady() {
    this.firstUserInfoDBCarniceria();
    this.firstUserInfoDBCharcuteria();
    this.firstUserInfoDBPescaderia();
    super.onReady();
  }

  @override
  void onClose() {
    this.listenerCarniceria.cancel();
    this.listenerCharcuteria.cancel();
    this.listenerPescaderia.cancel();
    super.onClose();
  }

  void firstUserInfoDBCarniceria() {
    if (_marketId != 'marketid' || _marketId != null) {
      var _firstUserInfo = _turnRealTimeDB
          .child(_marketId)
          .child('cola_espera')
          .child('carniceria')
          .orderByKey()
          .limitToFirst(1);
      this.listenerCarniceria = _firstUserInfo.onValue.listen((event) async {
        final _firstUserData = event.snapshot.value;
        if (_firstUserData != null) {
          turnUserInfoCarniceria = await TurnProvider().getUserTurnInfo('carniceria');
          if (turnUserInfoCarniceria.length > 0) {
            _firstUserData.forEach((key, value) {
              this.firstUserNumberCarniceria.value = value['num'];
              this.numUsersCarniceria.value =
                  turnUserInfoCarniceria[0]['num'] - this.firstUserNumberCarniceria.value;
            });
          }
        }
      });
      print('No tiene supermercado');
    }
  }

  void firstUserInfoDBCharcuteria() {
    if (_marketId != 'marketid' || _marketId != null) {
      var _firstUserInfo = _turnRealTimeDB
          .child(_marketId)
          .child('cola_espera')
          .child('charcuteria')
          .orderByKey()
          .limitToFirst(1);
      this.listenerCharcuteria = _firstUserInfo.onValue.listen((event) async {
        final _firstUserData = event.snapshot.value;
        if (_firstUserData != null) {
          turnUserInfoCharcuteria = await TurnProvider().getUserTurnInfo('charcuteria');
          if (turnUserInfoCharcuteria.length > 0) {
            _firstUserData.forEach((key, value) {
              this.firstUserNumberCharcuteria.value = value['num'];
              this.numUsersCharcuteria.value =
                  turnUserInfoCharcuteria[0]['num'] - this.firstUserNumberCharcuteria.value;
            });
          }
        }
      });
      print('No tiene supermercado');
    }
  }

  void firstUserInfoDBPescaderia() {
    if (_marketId != 'marketid' || _marketId != null) {
      var _firstUserInfo = _turnRealTimeDB
          .child(_marketId)
          .child('cola_espera')
          .child('pescaderia')
          .orderByKey()
          .limitToFirst(1);
      this.listenerPescaderia = _firstUserInfo.onValue.listen((event) async {
        final _firstUserData = event.snapshot.value;
        if (_firstUserData != null) {
          turnUserInfoPescaderia = await TurnProvider().getUserTurnInfo('pescaderia');
          if (turnUserInfoPescaderia.length > 0) {
            _firstUserData.forEach((key, value) {
              this.firstUserNumberPescaderia.value = value['num'];
              this.numUsersPescaderia.value =
                  turnUserInfoPescaderia[0]['num'] - this.firstUserNumberPescaderia.value;
            });
          }
        }
      });
      print('No tiene supermercado');
    }
  }
}

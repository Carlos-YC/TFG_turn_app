import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:tfg_app/src/config/config.dart';

class TurnProvider {
  String _marketId;
  String _adminService;
  String _uid;

  TurnProvider() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._adminService = SupermarketApp.sharedPreferences.getString(SupermarketApp.service);
    this._uid = SupermarketApp.auth.currentUser.uid;
  }

  Future<bool> readQRSupermarket() async {
    bool _isScanDB;
    String _qrScan;

    try {
      _qrScan = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
    } on PlatformException {
      _qrScan = 'Se ha producido un error';
    }

    (_qrScan != '-1') ? _isScanDB = await isSupermarket(_qrScan) : _isScanDB = false;
    return _isScanDB;
  }

  Future<bool> isSupermarket(String qrScan) async {
    final _refDB = FirebaseDatabase.instance.reference();

    final response1 = await _refDB.orderByKey().equalTo(qrScan).once();
    if (response1.value != null) {
      await SupermarketApp.sharedPreferences.setString(SupermarketApp.marketId, qrScan);
      return true;
    } else {
      return false;
    }
  }

  Future<void> createTurn(String supermarketId, String service) async {
    var _refDB = FirebaseDatabase.instance
        .reference()
        .child(supermarketId)
        .child('cola_espera')
        .child(service);
    var _lastKeyRef = _refDB.orderByChild('num').limitToLast(1);

    DateTime _timeNow = new DateTime.now();
    int _lastNumber;
    int _setNumber;
    String _token = await FirebaseMessaging.instance.getToken();

    await _lastKeyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> _values = snapshot.value;
        _values.forEach((key, value) {
          _lastNumber = value['num'] + 1;
          _setNumber = value['tu_num'] + 1;
        });

        if (_setNumber > 99) _setNumber = 1;

        if (_lastNumber < 10) {
          _refDB.child('${service}_00$_lastNumber').set({
            'app': true,
            'id_usuario': _uid,
            'fecha': _timeNow.toString(),
            'num': _lastNumber,
            'tu_num': _setNumber,
            'token': _token,
          });
        } else if (_lastNumber > 9 && _lastNumber < 100) {
          _refDB.child('${service}_0$_lastNumber').set({
            'app': true,
            'id_usuario': _uid,
            'fecha': _timeNow.toString(),
            'num': _lastNumber,
            'tu_num': _setNumber,
            'token': _token,
          });
        } else if (_lastNumber > 99) {
          _refDB.child('${service}_$_lastNumber').set({
            'app': true,
            'id_usuario': _uid,
            'fecha': _timeNow.toString(),
            'num': _lastNumber,
            'tu_num': _setNumber,
            'token': _token,
          });
        }
      } else {
        _refDB.child('${service}_001').set({
          'app': true,
          'id_usuario': _uid,
          'fecha': _timeNow.toString(),
          'num': 1,
          'tu_num': 1,
          'token': _token,
        });
      }
    });
  }

  Future<List> getUserTurnInfo(String service) async {
    List turnUserInfo = [];
    var _refDB = FirebaseDatabase.instance
        .reference()
        .child(_marketId)
        .child('cola_espera')
        .child('charcuteria');
    var _userLogged = _refDB.orderByChild('id_usuario').equalTo(_uid);

    await _userLogged.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        turnUserInfo.clear();
        Map<dynamic, dynamic> _values = snapshot.value;
        _values.forEach((key, value) {
          turnUserInfo.add(value);
        });
      }
    });
    return turnUserInfo;
  }

  Future<int> getClientTurnNumber() async {
    int turnUserNumber;
    var _refDB = FirebaseDatabase.instance
        .reference()
        .child(_marketId)
        .child('cola_espera')
        .child('charcuteria');
    var _userLogged = _refDB.orderByChild('num').limitToFirst(1);

    await _userLogged.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> _values = snapshot.value;
        _values.forEach((key, value) {
          turnUserNumber = value['tu_num'];
        });
      }
    });
    return turnUserNumber;
  }

  Future<void> nextTurn() async {
    var _refDB = FirebaseDatabase.instance
        .reference()
        .child(_marketId)
        .child('cola_espera')
        .child(_adminService);

    await _refDB.limitToFirst(1).once().then((event) async {
      Map map = event.value;
      String keyToDelete = map.keys.toList()[0].toString();
      await _refDB
          .child(keyToDelete)
          .remove()
          .then((_) => print('$keyToDelete se borró correctamente'));
    });
  }

  Future<void> cancelTurn(String service) async {
    var _refDB = FirebaseDatabase.instance
        .reference()
        .child(_marketId)
        .child('cola_espera')
        .child(service);
    var _userLogged = _refDB.orderByChild('id_usuario').equalTo(_uid);

    await _userLogged.once().then((event) async {
      if (event.value != null) {
        Map map = event.value;
        String keyToDelete = map.keys.toList()[0].toString();
        await _refDB.child(keyToDelete).remove().then((_) async {
          print('$keyToDelete se borró correctamente');
        });
      }
    });
  }
}

import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';

class TurnProvider {
  final String _uid = SupermarketApp.auth.currentUser.uid;
  final _turnRef = FirebaseDatabase.instance
      .reference()
      .child('codigo_supermercado')
      .child('cola_espera')
      .child('charcuteria');

  Future<bool> readQR() async {
    bool _isScanDB;
    String _qrScan;
    try {
      _qrScan = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
    } on PlatformException {
      _qrScan = 'Se ha producido un error';
    }
    (_qrScan != '-1') ? _isScanDB = _qrService(_qrScan) : _isScanDB = false;
    if (_isScanDB) await createTurn();
    return _isScanDB;
  }

  bool _qrService(String qrScan) {
    var _arr = qrScan.split(',');
    switch (_arr[1]) {
      case 'charcuteria':
        return true;
      case 'pescaderia':
        return true;
      case 'carniceria':
        return true;
      default:
        return false;
    }
  }

  Future<void> createTurn() async {
    var _lastKeyRef = _turnRef.orderByChild('num').limitToLast(1);
    DateTime _timeNow = new DateTime.now();
    int _lastNumber;
    int _setNumber;

    await _lastKeyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> _values = snapshot.value;
        _values.forEach((key, value) {
          _lastNumber = value['num'] + 1;
          _setNumber = value['tu_num'] + 1;
        });

        if (_setNumber > 99) _setNumber = 1;

        _turnRef.child('charcuteria_$_lastNumber').set({
          'app': true,
          'id_usuario': _uid,
          'fecha': _timeNow.toString(),
          'num': _lastNumber,
          'tu_num': _setNumber,
        });
      } else {
        _turnRef.child('charcuteria_1').set({
          'app': true,
          'id_usuario': _uid,
          'fecha': _timeNow.toString(),
          'num': 1,
          'tu_num': 1,
        });
      }
    });
  }

  Future<List> getUserTurnInfo() async {
    List turnUserInfo = [];
    var _userLogged = _turnRef.orderByChild('id_usuario').equalTo(_uid);
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

  Future<void> nextTurn() async {
    eliminateTurn();
  }

  Future<void> eliminateTurn() async {}

  Future<void> updateTurnInformation() async {}
}

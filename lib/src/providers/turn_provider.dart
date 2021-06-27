import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

import 'package:tfg_app/src/config/config.dart';

class TurnProvider {
  var _dbReference;
  String _marketId;
  String _adminService;
  String _uid;

  TurnProvider() {
    _dbReference = FirebaseDatabase.instance.reference();
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
    final response1 = await _dbReference.orderByKey().equalTo(qrScan).once();
    if (response1.value != null) {
      await SupermarketApp.sharedPreferences.setString(SupermarketApp.marketId, qrScan);
      return true;
    } else {
      return false;
    }
  }

  Future<void> createTurn(String supermarketId, String service) async {
    var _refDB = _dbReference.child(supermarketId).child('cola_espera').child(service);
    var _lastKeyRef = _refDB.orderByChild('num').limitToLast(1);

    String _token = await FirebaseMessaging.instance.getToken();
    DateTime _timeNow = DateTime.now();
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
    var _refDB = _dbReference.child(_marketId).child('cola_espera').child(service);
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

  Future<int> nextTurn(bool isClientThere) async {
    var _refDB = _dbReference.child(_marketId).child('cola_espera').child(_adminService);
    int _timeNowUnix;

    await _refDB.limitToFirst(1).once().then((event) async {
      Map map = event.value;
      print('${map.values.toList()[0]['id_usuario']} - ${map.values.toList()[0]['fecha']}');
      if (isClientThere) {
        _timeNowUnix = DateTime.now().toUtc().millisecondsSinceEpoch;
        await saveTurnHistory(
            _timeNowUnix, map.values.toList()[0]['id_usuario'], map.values.toList()[0]['fecha']);
      }
      String keyToDelete = map.keys.toList()[0].toString();
      await _refDB
          .child(keyToDelete)
          .remove()
          .then((_) => print('$keyToDelete se borró correctamente'));
    });
    return _timeNowUnix;
  }

  Future<void> saveTurnHistory(int timeUnix, String userId, String date) async {
    var _refDB = _dbReference
        .child(this._marketId)
        .child('cola_espera')
        .child('tiempos_espera')
        .child(this._adminService);

    String _timeNow = DateFormat('Hms').format(DateTime.now());
    List<String> _selectTurnTime = date.split(' ');

    String _adminId = SupermarketApp.sharedPreferences.getString(SupermarketApp.userUID);
    if (userId == null) userId = 'No app';

    await _refDB.child(timeUnix.toString()).set({
      'id_usuario': userId,
      'id_admin': _adminId,
      'fecha': _selectTurnTime[0],
      'fecha_pedir_turno': _selectTurnTime[1],
      'fecha_atendido': _timeNow,
    });
  }

  Future<void> cancelTurn(String service) async {
    var _refDB = _dbReference.child(_marketId).child('cola_espera').child(service);
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

  Future<void> finishTurnAndUpdate(int key, int seconds) async {
    var _refDB = _dbReference
        .child(this._marketId)
        .child('cola_espera')
        .child('tiempos_espera')
        .child(this._adminService);

    await _refDB.child('$key').update({'fecha_finalizacion': seconds});
  }

  Future<String> waitTurnTime(int queue, service) async {
    String _averageTimeTransform = '';
    var _refDB;
    if (service != '') {
      _refDB = _dbReference
          .child(this._marketId)
          .child('cola_espera')
          .child('tiempos_espera')
          .child(service);
    } else {
      _refDB = _dbReference
          .child(this._marketId)
          .child('cola_espera')
          .child('tiempos_espera')
          .child(this._adminService);
    }

    final _historyClientsTimes = await _refDB.orderByKey().limitToLast(queue).once();
    if (_historyClientsTimes.value != null) {
      final _history = _historyClientsTimes.value;
      final int _historyTimesLength = _historyClientsTimes.value.length;
      double _historyAllTimes = 0;
      double _averageTime = 0;

      _history.forEach((key, value) {
        if (value['fecha_pedir_turno'] != null &&
            value['fecha_pedir_turno'] != '' &&
            value['fecha_atendido'] != null &&
            value['fecha_atendido'] != '') {
          List<String> _firstTime = value['fecha_pedir_turno'].split(':');
          double _first = double.parse(_firstTime[0]) * 3600 +
              double.parse(_firstTime[1]) * 60 +
              double.parse(_firstTime[2]);

          List<String> _secondTime = value['fecha_atendido'].split(':');
          double _second = double.parse(_secondTime[0]) * 3600 +
              double.parse(_secondTime[1]) * 60 +
              double.parse(_secondTime[2]);

          _historyAllTimes += _second - _first;
        }
      });

      if (_historyAllTimes > 0 && _historyTimesLength > 0) {
        _averageTime = _historyAllTimes / _historyTimesLength;

        int minutes = (_averageTime / 60).truncate();
        _averageTimeTransform = minutes.toString().padLeft(2, '0');
      }
    }
    return _averageTimeTransform;
  }

  Future<String> serviceTurnTime(int queue) async {
    String _averageTimeTransform = '';
    var _refDB = _dbReference
        .child(this._marketId)
        .child('cola_espera')
        .child('tiempos_espera')
        .child(this._adminService);

    final _historyClientsTimes = await _refDB.orderByKey().limitToLast(queue).once();
    if (_historyClientsTimes.value != null) {
      final _history = _historyClientsTimes.value;
      int _historyTimesLength = 0;
      int _historyAllTimes = 0;
      double _averageTime = 0;

      _history.forEach((key, value) {
        if (value['id_admin'] == this._uid) {
          if (value['fecha_finalizacion'] != null && value['fecha_finalizacion'] > 45) {
            _historyTimesLength++;
            _historyAllTimes += value['fecha_finalizacion'];
          }
        }
      });

      if (_historyAllTimes > 0 && _historyTimesLength > 0) {
        _averageTime = _historyAllTimes / _historyTimesLength;

        int minutes = (_averageTime / 60).truncate();
        _averageTimeTransform = minutes.toString().padLeft(2, '0');
      }
    }
    return _averageTimeTransform;
  }
}

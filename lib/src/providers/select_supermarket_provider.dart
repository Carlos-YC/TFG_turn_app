import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/services.dart';
import 'package:tfg_app/src/config/config.dart';

class SupermarketProvider {
  final _refDB = FirebaseDatabase.instance.reference();
  String _supermarketID;

  SupermarketProvider() {
    this._supermarketID = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
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
    final response1 = await _refDB.orderByKey().equalTo(qrScan).once();
    if (response1.value != null) {
      await SupermarketApp.sharedPreferences.setString(SupermarketApp.marketId, qrScan);
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> supermarketInfo() async {
    List<String> servicesList = [];
    final _marketInfo = _refDB.child(_supermarketID).child('informacion');

    final name = await _marketInfo.child('cadena').once();
    if (name.value != null) {
      servicesList.add(name.value);
      final location = await _marketInfo.child('localizacion').once();
      if (location.value != null) {
        servicesList.add(location.value);
      }
    }
    return servicesList;
  }

  Future<void> logoutSupermarket() async {
    await SupermarketApp.sharedPreferences.setString(SupermarketApp.marketId, 'marketid');
    await SupermarketApp.sharedPreferences.setString(SupermarketApp.service, 'servicio');
  }
}

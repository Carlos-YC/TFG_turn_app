import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/services.dart';
import 'package:tfg_app/src/config/config.dart';

class SupermarketProvider {
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

  Future<void> logoutSupermarket() async {
    await SupermarketApp.sharedPreferences.setString(SupermarketApp.marketId, 'marketid');
    await SupermarketApp.sharedPreferences.setString(SupermarketApp.service, 'servicio');
  }
}

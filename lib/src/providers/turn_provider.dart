import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class TurnProvider {
  Future<bool> readQR() async {
    Future<bool> _isScanDB;
    String _qrScan;
    try {
      _qrScan = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
      _isScanDB = saveQRInfo();
    } on PlatformException {
      _qrScan = 'Se ha producido un error';
    }
    print(_qrScan);
    return _isScanDB;
  }

  Future<bool> saveQRInfo() async {
    return true;
  }

  Future<bool> hasTurn() async {}

  Future<void> createTurn() async {}

  Future<void> getTurn() async {}

  Future<void> nextTurn() async {
    eliminateTurn();
  }

  Future<void> eliminateTurn() async {}

  Future<void> updateTurnInformation() async {}
}

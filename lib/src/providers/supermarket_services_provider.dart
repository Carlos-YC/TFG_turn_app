import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/config/config.dart';

class SupermarketServicesProvider {
  String _supermarketID;

  SupermarketServicesProvider() {
    this._supermarketID = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
  }

  Future<List<String>> supermarketServices() async {
    List<String> servicesList = [];
    await FirebaseDatabase.instance
        .reference()
        .child(_supermarketID)
        .child('informacion')
        .child('servicios')
        .once()
        .then((snapshot) {
      if (snapshot.value != null) {
        servicesList = snapshot.value.split(',');
      }
    });
    return servicesList;
  }
}

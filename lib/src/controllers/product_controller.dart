import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/models/product_model.dart';

class ListProductController extends GetxController {
  final _productsRealTimeDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> listener;
  RxList<ProductModel> productList = <ProductModel>[].obs;

  String _marketId;
  String _adminService;

  ListProductController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._adminService = SupermarketApp.sharedPreferences.getString(SupermarketApp.service);
  }

  @override
  void onReady() {
    this.getProductsRealTime();
    super.onReady();
  }

  @override
  void onClose() {
    this.listener.cancel();
    super.onClose();
  }

  void getProductsRealTime() {
    this.listener = _productsRealTimeDB
        .child(_marketId)
        .child('productos')
        .child(_adminService)
        .orderByChild('disponible')
        .onValue
        .listen((event) {
      final _products = event.snapshot.value;
      if (_products != null) {
        this.productList.clear();
        _products.forEach((key, value) {
          this.productList.add(ProductModel.fromJson(jsonEncode(value)));
        });
      }
    });
  }

  void updateAvailable(String id, bool available) {
    var _modifyProduct =
        _productsRealTimeDB.child(_marketId).child('productos').child(_adminService);
    if (available) {
      _modifyProduct.child(id).update({'disponible': false});
    } else {
      _modifyProduct.child(id).update({'disponible': true});
    }
  }
}

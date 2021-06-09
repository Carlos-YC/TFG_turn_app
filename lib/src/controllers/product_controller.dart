import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/models/product_model.dart';

class ListProductController extends GetxController {
  final _productsRealTimeDB = FirebaseDatabase.instance
      .reference()
      .child('codigo_supermercado')
      .child('productos')
      .child('charcuteria');

  StreamSubscription<Event> listener;
  RxList<ProductModel> productList = <ProductModel>[].obs;

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
    this.listener = _productsRealTimeDB.onValue.listen((event) {
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
    if (available) {
      _productsRealTimeDB.child(id).update({'disponible': false});
    } else {
      _productsRealTimeDB.child(id).update({'disponible': true});
    }
  }
}

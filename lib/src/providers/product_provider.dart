import 'dart:convert';

import 'package:tfg_app/src/config/config.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:tfg_app/src/models/product_model.dart';

class ProductProvider {
  String _supermarketID;

  ProductProvider() {
    this._supermarketID = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
  }

  Future<List<ProductModel>> productList(String service) async {
    final _productsDB = FirebaseDatabase.instance
        .reference()
        .child(_supermarketID)
        .child('productos')
        .child(service);
    List<ProductModel> _productsList = [];
    final response = await _productsDB.once();
    if (response.value != null) {
      final _products = response.value;
      _productsList.clear();
      _products.forEach((key, value) {
        if (value['disponible']) _productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }
    return _productsList;
  }
}

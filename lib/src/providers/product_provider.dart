import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:tfg_app/src/models/product_model.dart';

class ProductProvider {

  final _productsDB = FirebaseDatabase.instance
      .reference()
      .child('codigo_supermercado')
      .child('productos')
      .child('charcuteria');
  
  Future<List<ProductModel>> productList() async {
    List<ProductModel> _productsList = [];
    await _productsDB.orderByChild('tipo').once().then((DataSnapshot snapshot) {
      if(snapshot.value != null) {
        final _products = snapshot.value;
        _productsList.clear();
        _products.forEach((key, value) {
          if(value['disponible']) _productsList.add(ProductModel.fromJson(jsonEncode(value)));
        });
      }
    });
    return _productsList;
  }
}
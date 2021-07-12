import 'dart:convert';

import 'package:tfg_app/src/config/config.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:tfg_app/src/models/product_model.dart';

class ProductProvider {
  String _supermarketID;
  List<ProductModel> _productsList;

  ProductProvider() {
    this._supermarketID = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._productsList = [];
  }

  Future<List<ProductModel>> productListAll() async {
    this._productsList.clear();

    await productList('carniceria');
    await productList('charcuteria');
    await productList('pescaderia');

    return this._productsList;
  }

  Future<List<ProductModel>> productList(String service) async {
    final _productsDB =
        FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');

    final response = await _productsDB.child(service).once();
    if (response.value != null) {
      final _products = response.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }

  Future<List<ProductModel>> productListAllOffers() async {
    this._productsList.clear();

    await productListOffers('carniceria');
    await productListOffers('charcuteria');
    await productListOffers('pescaderia');

    return this._productsList;
  }

  Future<List<ProductModel>> productListOffers(String service) async {
    final _productsDB =
    FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');

    final response = await _productsDB.child(service).once();
    if (response.value != null) {
      final _products = response.value;
      _products.forEach((key, value) {
        if (value['disponible'] && value['oferta'] && value['descuento'] > 0)
          this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }
}
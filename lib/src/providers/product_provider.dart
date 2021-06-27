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

  Future<List<ProductModel>> productList() async {
    final _productsDB =
        FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');
    this._productsList.clear();

    final responseCarniceria = await _productsDB.child('carniceria').once();
    if (responseCarniceria.value != null) {
      final _products = responseCarniceria.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    final responseCharcuteria = await _productsDB.child('charcuteria').once();
    if (responseCharcuteria.value != null) {
      final _products = responseCharcuteria.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    final responsePescaderia = await _productsDB.child('pescaderia').once();
    if (responsePescaderia.value != null) {
      final _products = responsePescaderia.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }

  Future<List<ProductModel>> productListCarniceria() async {
    final _productsDB =
        FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');
    this._productsList.clear();

    final responseCarniceria = await _productsDB.child('carniceria').once();
    if (responseCarniceria.value != null) {
      final _products = responseCarniceria.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }

  Future<List<ProductModel>> productListCharcuteria() async {
    final _productsDB =
        FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');
    this._productsList.clear();

    final responseCharcuteria = await _productsDB.child('charcuteria').once();
    if (responseCharcuteria.value != null) {
      final _products = responseCharcuteria.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }

  Future<List<ProductModel>> productListPescaderia() async {
    final _productsDB =
        FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');
    this._productsList.clear();

    final responsePescaderia = await _productsDB.child('pescaderia').once();
    if (responsePescaderia.value != null) {
      final _products = responsePescaderia.value;
      _products.forEach((key, value) {
        if (value['disponible']) this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }

  Future<List<ProductModel>> productListOffers() async {
    final _productsDB =
        FirebaseDatabase.instance.reference().child(_supermarketID).child('productos');
    this._productsList.clear();

    final responseCarniceria = await _productsDB.child('carniceria').once();
    if (responseCarniceria.value != null) {
      final _products = responseCarniceria.value;
      _products.forEach((key, value) {
        if (value['disponible'] && value['oferta'] && value['descuento'] > 0)
          this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    final responseCharcuteria = await _productsDB.child('charcuteria').once();
    if (responseCharcuteria.value != null) {
      final _products = responseCharcuteria.value;
      _products.forEach((key, value) {
        if (value['disponible'] && value['oferta'] && value['descuento'] > 0)
          this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    final responsePescaderia = await _productsDB.child('pescaderia').once();
    if (responsePescaderia.value != null) {
      final _products = responsePescaderia.value;
      _products.forEach((key, value) {
        if (value['disponible'] && value['oferta'] && value['descuento'] > 0)
          this._productsList.add(ProductModel.fromJson(jsonEncode(value)));
      });
    }

    return this._productsList;
  }
}

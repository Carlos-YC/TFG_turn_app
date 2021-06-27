import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/models/product_model.dart';
import 'package:tfg_app/src/providers/product_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<List<ProductModel>> _future = ProductProvider().productList();
  String _selectedOption = 'Ver todo';
  List<String> _productsOptions = [
    'Ver todo',
    'Carniceria',
    'Charcuteria',
    'Pescaderia',
    'Descuentos'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomBoxDecoration(
          color1: Colors.lightGreen,
          color2: Colors.green,
        ),
        title: Text(
          'Productos',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        actions: [_dropDown()],
      ),
      body: _productsTable(),
    );
  }

  List<DropdownMenuItem<String>> getOptionsDropDown() {
    List<DropdownMenuItem<String>> list = [];

    _productsOptions.forEach((option) {
      list.add(DropdownMenuItem(child: Text(option), value: option));
    });

    return list;
  }

  Widget _dropDown() {
    return DropdownButton(
      value: _selectedOption,
      items: getOptionsDropDown(),
      dropdownColor: Colors.green,
      onChanged: (opt) {
        setState(() {
          _selectedOption = opt;
          switch (opt) {
            case 'Ver todo':
              _future = ProductProvider().productList();
              break;
            case 'Carniceria':
              _future = ProductProvider().productListCarniceria();
              break;
            case 'Charcuteria':
              _future = ProductProvider().productListCharcuteria();
              break;
            case 'Pescaderia':
              _future = ProductProvider().productListPescaderia();
              break;
            case 'Descuentos':
              _future = ProductProvider().productListOffers();
              break;
          }
        });
      },
    );
  }

  Widget _productsTable() {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator()
          );
        } else if (snapshot.data.length < 1) {
          return Center(
            child: Text(
              'No hay productos disponibles para ver',
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          List<Widget> listProducts = [];
          snapshot.data.map((product) {
            if (product.disponible == true) {
              listProducts.add(
                InkWell(
                  onTap: () {
                    Get.toNamed('detailsProduct', arguments: product);
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.teal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _checkUrl(product.imagenUrl),
                        _productInfo(product),
                      ],
                    ),
                  ),
                ),
              );
            }
          }).toString();

          return GridView.count(
            physics: BouncingScrollPhysics(),
            primary: false,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            crossAxisSpacing: 2.5,
            mainAxisSpacing: 2.5,
            crossAxisCount: 2,
            children: listProducts,
          );
        }
      },
    );
  }

  Widget _checkUrl(String imgUrl) {
    return Expanded(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Hero(
          tag: imgUrl,
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
              return Icon(Icons.image, size: 48.0);
            },
          ),
        ),
      ),
    );
  }

  Widget _productInfo(ProductModel product) {
    return Column(
      children: [
        _hasDiscount(product),
        FractionalTranslation(
          translation: Offset(0, -0.5),
          child: Text(
            product.nombre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _hasDiscount(ProductModel product) {
    if (product.oferta && product.descuento > 0) {
      double discountPrice = product.precioKg - (product.precioKg * (product.descuento / 100));
      return FractionalTranslation(
        translation: Offset(0, -0.5),
        child: Container(
          width: 130,
          height: 40,
          child: Center(
            child: Text(
              '${discountPrice.toStringAsFixed(2)} €/Kg',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green[800],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 4, color: Colors.red[800]),
          ),
        ),
      );
    } else {
      return FractionalTranslation(
        translation: Offset(0, -0.5),
        child: Container(
          width: 90,
          height: 40,
          child: Center(
            child: Text(
              '${product.precioKg.toStringAsFixed(2)} €/Kg',
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 3, color: Colors.white),
          ),
        ),
      );
    }
  }
}

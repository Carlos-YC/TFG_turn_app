import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:tfg_app/src/controllers/product_controller.dart';
import 'package:tfg_app/src/models/product_model.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListProductController>(
      init: ListProductController(),
      builder: (controller) => Scaffold(
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
        ),
        body: _productsTable(controller),
      ),
    );
  }

  Widget _productsTable(ListProductController controller) {
    return Obx(() {
      if (controller.productList.length == 0) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        List<Widget> listProduct = [];
        controller.productList.map((product) {
          if (product.disponible == true) {
            listProduct.add(
              InkWell(
                onTap: () {
                  //Get.toNamed('detailsProduct', arguments: product.id);
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
          children: listProduct,
        );
      }
    });
  }

  Widget _checkUrl(String imgUrl) {
    return Expanded(
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
    );
  }

  Widget _productInfo(ProductModel product) {
    return Column(
      children: [
        FractionalTranslation(
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
        ),
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
}

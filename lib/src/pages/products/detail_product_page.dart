import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/models/product_model.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomBoxDecoration(
          color1: Colors.lightGreen,
          color2: Colors.green,
        ),
        title: Text(
          'Información',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
      body: SingleChildScrollView(child: _productInfo(context, product)),
    );
  }

  Widget _productInfo(BuildContext context, ProductModel product) {
    return Container(
      child: Column(
        children: [
          _topInfo(context, product),
          SizedBox(height: 20.0),
          _bottomInfo(product),
        ],
      ),
    );
  }

  Widget _topInfo(BuildContext context, ProductModel product) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: product.imagenUrl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: _checkUrl(product.imagenUrl),
            ),
          ),
          SizedBox(width: 30.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.nombre, style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 10.0),
                Text(product.marca, style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 5.0),
                _productPrice(product)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomInfo(ProductModel product) {
    return Column(
      children: [
        _buttonExpanded('Ingredientes', 1, product),
        _buttonExpanded('Alergenos', 2, product),
        _buttonExpanded('Inf. Nutricional (100g)', 3, product),
        _buttonExpanded('Más Inf.', 4,  product),
      ],
    );
  }

  Widget _checkUrl(String imgUrl) {
    return Image.network(
      imgUrl,
      height: 150.0,
      width: 150.0,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
        return Icon(Icons.image, size: 48.0);
      },
    );
  }

  Widget _productPrice(ProductModel product) {
    if (product.oferta && product.descuento > 0) {
      double discountPrice = product.precioKg - (product.precioKg * (product.descuento / 100));
      return Column(
        children: [
          Row(
            children: [
              Text(
                '${product.precioKg.toStringAsFixed(2)} €/Kg',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2.5,
                ),
              ),
              SizedBox(width: 15.0),
              Text(
                '${discountPrice.toStringAsFixed(2)} €/Kg',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ],
      );
    } else {
      return Text('${product.precioKg.toString()} €/Kg',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold));
    }
  }

  Widget _buttonExpanded(String title, int index, ProductModel product) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.teal,
          backgroundColor: Colors.teal,
          childrenPadding: EdgeInsets.all(5.0),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          children: [_selectOption(index, product)],
        ),
      ),
    );
  }

  _selectOption(int index, ProductModel product) {
    switch (index) {
      case 1:
        return _normalInfo(product.ingredientes);
      case 2:
        return _normalInfo(product.alergenos);
      case 3:
        return _tableInfo(product.informacionNutricional);
      case 4:
        return _moreInfo(product);
    }
  }

  Widget _normalInfo(List<String> productInfo) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: productInfo.length,
      itemBuilder: (BuildContext context, int index) {
        final String info = productInfo[index];
        return Container(
          padding: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
          child: Text('- $info'),
        );
      },
    );
  }

  Widget _tableInfo(InformacionNutricional nutritionalInfo) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Table(
        border: TableBorder.all(color: Colors.white),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _tableRow(' Valor energético', '${nutritionalInfo.energeticoKcal.toString()} Kcal'),
          _tableRow(' Grasas', nutritionalInfo.grasas.toString()),
          _tableRow(' Grasas saturadas', nutritionalInfo.grasasSaturadas.toString()),
          _tableRow(' Hidratos de carbono', nutritionalInfo.hidratosCarbono.toString()),
          _tableRow(' Azúcares', nutritionalInfo.azucares.toString()),
          _tableRow(' Proteínas', nutritionalInfo.proteinas.toString()),
          _tableRow(' Sal', nutritionalInfo.sal.toString()),
        ],
      ),
    );
  }

  Widget _moreInfo(ProductModel product) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoText('Marca: ', product.marca),
          SizedBox(height: 10.0),
          _infoText('Proveedor: ', product.proveedor),
          SizedBox(height: 10.0),
          _infoText('Origen: ', product.origen),
        ],
      ),
    );
  }

  TableRow _tableRow(String title, String info) {
    return TableRow(children: [
      TableCell(
          child: Padding(
              padding: EdgeInsets.all(3),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)))),
      TableCell(child: Center(child: Container(child: Text(info)))),
    ]);
  }

  Widget _infoText(String info, String productInfo) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        children: [
          TextSpan(text: info, style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: productInfo)
        ],
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

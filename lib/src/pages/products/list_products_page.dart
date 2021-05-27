import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/controllers/product_controller.dart';
import 'package:tfg_app/src/models/product_model.dart';
import 'package:tfg_app/src/dialog/display_dialog.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class ListProductsPage extends StatefulWidget {
  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  RxList<ProductModel> _products;
  int _sortColumnIndex = 2;
  bool _isAscending = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListProductController>(
      init: ListProductController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: CustomBoxDecoration(
            color1: Colors.lightBlueAccent,
            color2: Colors.blue,
          ),
          title: Text('Productos', style: TextStyle(color: Colors.white, fontSize: 24.0)),
        ),
        body: _productsTable(controller),
      ),
    );
  }

  Widget _productsTable(ListProductController controller) {
    return Obx(() {
      if (controller.productList.length == 0) {
        return Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
        );
      } else {
        this._products = controller.productList;
        final columns = ['Producto', 'Tipo', 'Disponible'];
        return Container(
          padding: EdgeInsets.all(5.0),
          child: DataTable(
            showCheckboxColumn: false,
            sortAscending: _isAscending,
            sortColumnIndex: _sortColumnIndex,
            columns: _getColumns(columns),
            rows: _getRows(controller.productList),
          ),
        );
      }
    });
  }

  List<DataColumn> _getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: TextStyle(fontSize: 16.0),
            ),
            onSort: _onSort,
          ))
      .toList();

  List<DataRow> _getRows(RxList<ProductModel> productList) => productList.map((product) {
        final cells = [product.nombre, product.tipo, product.disponible];
        return DataRow(
            color: MaterialStateColor.resolveWith((states) {
              return (!product.disponible) ? Colors.blueGrey[400] : Colors.blue;
            }),
            cells: _getCells(cells),
            onSelectChanged: (bool selected) {
              if (selected) {
                if (product.disponible) {
                  DisplayDialog.displayAvailableDialog(
                      context, '¿Cambiar -${product.nombre}- a "NO DISPONIBLE"?', product.id, true);
                } else {
                  DisplayDialog.displayAvailableDialog(
                      context, '¿Cambiar -${product.nombre}- a "DISPONIBLE"?', product.id, false);
                }
              }
            });
      }).toList();

  List<DataCell> _getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _products.sort(
          (product1, product2) => _compareString(ascending, product1.nombre, product2.nombre));
    } else if (columnIndex == 1) {
      _products.sort((product1, product2) =>
          _compareString(ascending, '${product1.tipo}', '${product2.tipo}'));
    } else if (columnIndex == 2) {
      _products.sort((product1, product2) =>
          _compareString(ascending, '${product1.disponible}', '${product2.disponible}'));
    }
    setState(() {
      this._sortColumnIndex = columnIndex;
      this._isAscending = ascending;
    });
  }

  int _compareString(bool ascending, String product1, String product2) =>
      ascending ? product1.compareTo(product2) : product2.compareTo(product1);
}

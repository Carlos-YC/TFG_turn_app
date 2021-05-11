import 'package:flutter/material.dart';

import 'package:tfg_app/src/providers/product_provider.dart';
import 'package:tfg_app/src/dialog/display_dialog.dart';

class ListProductsPage extends StatefulWidget {
  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  List products;
  int sortColumnIndex;
  bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Para que sea adaptativo
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            'Productos',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
        body: _productsTable(context, size),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _productsTable(BuildContext context, Size size) {
    return Container(
      width: size.width * 1,
      height: size.height * 1,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: ProductProvider().getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print('Error');
              if (!snapshot.hasData) return CircularProgressIndicator();
              products = snapshot.data;
              return _createDataTable(snapshot);
            },
          ),
        ),
      ),
    );
  }

  Widget _createDataTable(AsyncSnapshot snapshot) {
    final columns = ['Producto', 'Tipo', 'Disponible'];

    return DataTable(
      showCheckboxColumn: false,
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: _getColumns(columns, snapshot),
      rows: _getRows(snapshot),
    );
  }

  List<DataColumn> _getColumns(List<String> columns, AsyncSnapshot snapshot) =>
      columns.map((String column) => DataColumn(label: Text(column), onSort: _onSort)).toList();

  List<DataRow> _getRows(AsyncSnapshot products) => products.data.map<DataRow>((product) {
        final cells = [product['nombre'], product['tipo'], product['disponible']];
        return DataRow(
          cells: _getCells(cells),
            onSelectChanged: (bool selected) {
              if (selected) {
                if (product['disponible']) {
                  DisplayDialog.displayAvailableDialog(
                      context, '¿Cambiar -${product['nombre']}- a "NO DISPONIBLE"?', product['id'], true);
                } else {
                  DisplayDialog.displayAvailableDialog(
                      context, '¿Cambiar -${product['nombre']}- a "DISPONIBLE"?', product['id'], false);
                }
              }
            });
      }).toList();

  List<DataCell> _getCells(List cells) => cells.map((data) => DataCell(Text('$data'))).toList();

  void _onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      products.sort((product1, product2) =>
          _compareString(ascending, product1['nombre'], product2['nombre']));
    } else if (columnIndex == 1) {
      products.sort((product1, product2) =>
          _compareString(ascending, '${product1['tipo']}', '${product2['tipo']}'));
    } else if (columnIndex == 2) {
      products.sort((product1, product2) =>
          _compareString(ascending, '${product1['disponible']}', '${product2['disponible']}'));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int _compareString(bool ascending, String product1, String product2) =>
      ascending ? product1.compareTo(product2) : product2.compareTo(product1);
}

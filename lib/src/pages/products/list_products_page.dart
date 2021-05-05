import 'package:flutter/material.dart';
import 'package:tfg_app/src/providers/product_provider.dart';

class ListProductsPage extends StatefulWidget {
  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  List products;

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
              //if (snapshot.connectionState != ConnectionState.done) print('Error conexión');
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
      columns: _getColumns(columns, snapshot),
      rows: _getRows(snapshot),
    );
  }

  List<DataColumn> _getColumns(List<String> columns, AsyncSnapshot snapshot) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();

  List<DataRow> _getRows(AsyncSnapshot products) => products.data.map<DataRow>((product) {
        final cells = [product['nombre'], product['tipo'], product['disponible']];
        return DataRow(
          cells: _getCells(cells),
        );
      }).toList();

  List<DataCell> _getCells(List cells) => cells.map((data) => DataCell(Text('$data'))).toList();
}

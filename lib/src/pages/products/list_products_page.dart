import 'package:flutter/material.dart';

class ListProductsPage extends StatefulWidget {
  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
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
    return Container();
  }


}

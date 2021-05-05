import 'package:firebase_database/firebase_database.dart';

class ProductProvider {
  final _productReference =
      FirebaseDatabase.instance.reference().child('productos').child('charcuteria');

  Future<List> getAllProducts() async {
    final _db = _productReference;

    List _list = [];

    await _db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> _values = snapshot.value;
      _values.forEach((key, value) {
        _list.add(value);
      });
    });
    return _list;
  }
}

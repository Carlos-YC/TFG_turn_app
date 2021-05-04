import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupermarketApp {
  static const String appName = 'Supermarket turn App';

  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth;
  static FirebaseDatabase database;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';

  static final String userEmail = 'email';
  static final String userUID = 'uid';

  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
}

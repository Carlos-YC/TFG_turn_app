import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupermarketApp {
  static const String appName = 'Supermarket turn App';

  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth;
  static FirebaseDatabase database;

  static final String userEmail = 'email';
  static final String userUID = 'uid';
  static String userCartList = 'userCart';

  static List serviceSelected = [];

  static final String marketId = 'marketid';
  static final String service = 'servicio';
}

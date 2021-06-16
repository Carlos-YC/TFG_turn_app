import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tfg_app/src/services/remote/push_notification.service.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/models/notification_model.dart';

class AdminSendNotificationController extends GetxController {
  final _turnRealTimeDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> callUser;
  RxInt length = RxInt(0);
  RxBool hasApp = RxBool(false);

  String token;
  String _marketId;
  String _adminService;

  AdminSendNotificationController() {
    this._marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);
    this._adminService = SupermarketApp.sharedPreferences.getString(SupermarketApp.service);
  }

  @override
  void onReady() {
    this.thirdUserInfoRealTimeDB();
    super.onReady();
  }

  @override
  void onClose() {
    this.callUser.cancel();
    super.onClose();
  }

  void thirdUserInfoRealTimeDB() {
    var _userInfo = _turnRealTimeDB
        .child(_marketId)
        .child('cola_espera')
        .child(_adminService)
        .orderByKey()
        .limitToFirst(3);
    this.callUser = _userInfo.onValue.listen((event) async {
      final _userData = event.snapshot.value;
      if (_userData != null && _userData.length == 3) {
        String token;
        bool hasApp;
        _userData.forEach((key, value) {
          if (value['app']) {
            token = value['token'];
            hasApp = true;
          } else {
            hasApp = false;
          }
        });
        if (hasApp) {
          NotificationSendRequest notification = NotificationSendRequest(
            token: token,
            title: "TurnApp",
            body: "En breve será su turno. Por favor, acerquese al puesto. Gracias",
          );
          PushNotificationService service = PushNotificationService();
          await service.sendNotification(notification);
        }
      }
    });
  }
}
import 'package:dio/dio.dart';
import 'package:tfg_app/src/models/notification_model.dart';

class PushNotificationService {
  final _dio = Dio();

  PushNotificationService() {
    this._dio.options.baseUrl = 'https://tfg-app-cyc.herokuapp.com/api/notification';
  }

  Future<void> sendNotification(NotificationSendRequest notification) async {
    try {
      var response = await _dio.post('/send', data: notification.toJson());
      print(response);
    } catch (e) {
      print(e);
    }
  }
}

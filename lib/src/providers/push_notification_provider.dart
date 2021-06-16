import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static StreamController<String> _messageStreamController = new StreamController();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _message(RemoteMessage message) async {
    _messageStreamController.add(message.notification.title);
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessage.listen(_message);
    FirebaseMessaging.onMessageOpenedApp.listen(_message);
    FirebaseMessaging.onBackgroundMessage(_message);
  }

  static closeStreams() {
    _messageStreamController.close();
  }
}

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<String> _messageStreamController = new StreamController();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _onMessage(RemoteMessage message) async {
    //print('onMessage Handler ${message.messageId}');
    _messageStreamController.add(message.notification.title);
  }

  static Future _onMessageOpenedApp(RemoteMessage message) async {
    //print('OpenApp Handler ${message.messageId}');
    _messageStreamController.add(message.notification.title);
  }

  static Future _onBackgroundHandler(RemoteMessage message) async {
    //print('Terminated Handler ${message.messageId}');
    _messageStreamController.add(message.notification.title);
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');


    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  }

  static closeStreams() {
    _messageStreamController.close();
  }
}

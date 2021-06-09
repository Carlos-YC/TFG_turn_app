import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
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

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  }

  static closeStreams() {
    _messageStreamController.close();
  }

  Future<void> sendPostNotification(String token) async {
    String _authorization =
        'AAAAxtHL8pM:APA91bHkIpD9pwDLWn8xip0dCsGUB33Vrf-6C7PJHDm0AQtypQbKYTzNGR3gW6WwcephG1KCewugAJ1L4q3hsDayltLTnOzqZzLyLh9DCV1s20iYNNkSfTqJqxCMGVboNc4T9YhnFDFL';

    var headers = {'Authorization': 'key= $_authorization', 'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send?='));
    request.body = '''{
      "priority": "high",
      "notification": {
        "title": "Quedan 2 personas por delante de usted",
        "body": "Por favor, acérquese a la charcutería para no perder su turno. Gracias.",
      },
      "to": "$token",
    }''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}

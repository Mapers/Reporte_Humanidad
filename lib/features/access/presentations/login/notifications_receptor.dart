import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

typedef BackgroundMessageHandler = Future<dynamic> Function(Map<String, dynamic> message);

class NotificationsReceptor {

  void setFirebase(BackgroundMessageHandler backgroundMessageHandler) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');

    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelect);

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onBackgroundMessage: Platform.isIOS ? null : backgroundMessageHandler,
      onMessage: (message) async => backgroundMessageHandler(message),
      onLaunch: (message) async => backgroundMessageHandler(message),
      onResume: (message) async => backgroundMessageHandler(message),
    );

    String token = await _firebaseMessaging.getToken();
    print('token -> ' + token);
  }

  Future<String> onSelect(String data) async {
    print('onSelectNotification $data');
    return '';
  }
}

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();
  static final FirebaseNotificationService _instance =
  FirebaseNotificationService._();
  factory FirebaseNotificationService() {
    return _instance;
  }
  initialize() async {
    Firebase.initializeApp().whenComplete(() async {
      messaging = FirebaseMessaging.instance;
      await notificationPermission();
      String? token = await getToken();
      debugPrint(token);
      await getApnsToken();
      await initMessaging();
    });
  }

  FirebaseMessaging? messaging;

  FlutterLocalNotificationsPlugin fltNotification =
  FlutterLocalNotificationsPlugin();

  Future<String?> getToken() {
    return messaging!.getToken();
  }

  Future<String?> getApnsToken() {
    return messaging!.getAPNSToken();
  }

  Future<void> fcmSubscribe(String topic) async {
    try {
      var a = await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (e) {
      log('Log: ${e.toString()}');
    }
  }

  //FCM Unsubscribe Topic
  Future<void> fcmUnSubscribe(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<void> notificationPermission() async {
    await messaging!.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    await NotificationPermissions.requestNotificationPermissions(
      iosSettings:
      const NotificationSettingsIos(alert: true, badge: true, sound: true),
    );
    await messaging!.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  NotificationDetails? notificationDetails;

  var androidDetails = const AndroidNotificationDetails(
    'high_importance',
    "High importance notifications",
    icon: '@drawable/notification_icon',
    importance: Importance.max,
    playSound: true,
    priority: Priority.high,
    enableVibration: true,
  );

  Future<void> initMessaging() async {
    /// android
    AndroidNotificationChannel androidNotificationChannel =
    const AndroidNotificationChannel(
      "high_importance",
      "High importance notifications",
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    await fltNotification
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    notificationDetails = NotificationDetails(android: androidDetails);
    FirebaseMessaging.onMessage.listen((event) async {
      RemoteNotification? notification = event.notification;

      await FirebaseNotificationService().fltNotification.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          notificationDetails);
    });
  }
}

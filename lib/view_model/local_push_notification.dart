// coverage:ignore-file
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotification {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static showNotification(PushDetails pushDetails,
      {NotificationDetails? notificationDetails,
      FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin}) async {
    await (flutterLocalNotificationsPlugin ?? FlutterLocalNotificationsPlugin())
        .show(pushDetails.id, pushDetails.title, pushDetails.body,
            notificationDetails ?? getPlatformChannelSpecifics(),
            payload: pushDetails.payload);
  }

  static NotificationDetails getPlatformChannelSpecifics() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon');

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
  }

  LocalPushNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      initializeAndroid();
    } else if (Platform.isIOS) {
      initializeIOS();
    }
  }

  initializeAndroid() {
    checkAndroidPermission().then((value) {
      if (value == false) {
        return;
      }

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
      print('initializeAndroid');
    });
  }

  Future<bool?> checkAndroidPermission() async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  initializeIOS() {
    checkIOSPermission().then((value) {
      if (value == false) {
        return;
      }

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
              onDidReceiveLocalNotification: onDidReceiveLocalNotification);

      final InitializationSettings initializationSettings =
          InitializationSettings(iOS: initializationSettingsDarwin);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    });
  }

  Future<bool?> checkIOSPermission() async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    // final String? payload = notificationResponse.payload;
    print('onDidReceiveNotificationResponse called');
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print('onDidReceiveLocalNotification called');
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title??''),
    //     content: Text(body??''),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
}

class PushDetails {
  final int id;
  final String title;
  final String body;
  final String payload;

  PushDetails(this.id, this.title, this.body, this.payload);
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:template_flutter/config/firebase_options.dart';
import 'package:template_flutter/config/firebase_remote_config.dart';
import 'package:template_flutter/view/home.dart';
import 'package:template_flutter/view_model/local_push_notification.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  //TODO: only portrait mode, if you want to use landscape mode, remove this
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    RemoteConfig().setup();
    //TODO: when you want to use firebase, uncomment this
    // var firebaseApp = Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // firebaseApp.then((value) async {
    //   await RemoteConfig().setup();
    //   FirebaseMessaging.instance
    //       .requestPermission(provisional: true)
    //       .then((value) async {
    //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //       LocalPushNotification.showNotification(PushDetails(message.hashCode,
    //           message.notification!.title!, message.notification!.body!, ''));
    //     });
    //   });
    // });
    LocalPushNotification();

    return const MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('pt', 'BR')],
      home: HomeView(),
    );
  }
}

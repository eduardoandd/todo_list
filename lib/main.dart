import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todo_list/notifications/notification_helper.dart';
import 'package:todo_list/pages/main_app.dart';
import 'package:todo_list/pages/todo_page.dart';

import 'model/todo_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  var documentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);
  Hive.registerAdapter(ToDoModelAdapter());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance
      .getToken(vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu");

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if(message.notification != null){
      print(message.notification);
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    print("Obtendo novamente");
  }).onError((err) {
    print(err);
  });
  print(fcmToken);
  

  runApp(const MainApp());
}

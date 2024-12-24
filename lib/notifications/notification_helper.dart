import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    tz.initializeTimeZones();
  }

  static scheduledNotification(
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    var notifyTime = tz.TZDateTime.from(scheduledDate, tz.local);

    
    var androidDetails = AndroidNotificationDetails(
      "important_notification", 
      "My Channel", 
      channelDescription: "Canal de notificações para tarefas importantes",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "Nova tarefa adicionada!",
      color: Colors.purple, 
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), 
      styleInformation: BigTextStyleInformation(
        '<b>$body</b>',
        contentTitle: title,
        summaryText: 'Lembrete da sua tarefa!',
      ),
    );

    
    var iosDetails = DarwinNotificationDetails(
      subtitle: "Lembrete importante",
      sound: "custom_sound.aiff", 
      attachments: [
        DarwinNotificationAttachment('path/to/image.png'), 
      ],
    );

    
    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notification.zonedSchedule(
      0, 
      title, // Notification title
      body, // Notification body
      notifyTime, // Scheduled time
      notificationDetails, // Details of notification
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

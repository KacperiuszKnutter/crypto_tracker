import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotificationHandler {
  // Główna instancja pluginu do obsługi powiadomień
  final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();

  // Identyfikatory i parametry kanału powiadomień Android
  static const String channelId = "crypto_channel";
  static const String channelName = "Powiadomienia o kryptowalutach";
  static const String channelDescription = "Kanał do alarmów cen kryptowalut";

  // Kanał powiadomień Android 8.0+ wymagany
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  // Szczegóły powiadomienia
  final AndroidNotificationDetails _androidDetails = const AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  // Inicjalizacja powiadomień
  Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    // Tworzenie kanału oraz inicjalizacja pluginu
    await flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    await flnp.initialize(initSettings);

    // Opcjonalnie: pytamy o zgodę na powiadomienia Android 13+
    await flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  // Inicjalizacja strefy czasowej wymagane do zonedSchedule
  Future<void> configureLocalTimeZone() async {
    tzData.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
  }

  // Pokazuje natychmiastowe powiadomienie
  Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    await flnp.show(
      Random().nextInt(10000), // losowy ID, by nie nadpisywać starych
      title,
      body,
      NotificationDetails(android: _androidDetails),
    );
  }

  // Pokazuje zaplanowane powiadomienie o konkretnej godzinie
  Future<void> showZonedNotification({
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    await flnp.zonedSchedule(
      Random().nextInt(10000),
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      NotificationDetails(android: _androidDetails),
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
    print("✅ LocalNotificationService initialized");
  }

  /// Show a local notification
  static Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await init();

    const androidDetails = AndroidNotificationDetails(
      'healing_channel',
      'Healing Notifications',
      channelDescription: 'Appointment and health notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
    print("🔔 Notification shown: $title");
    } catch (e) {
      print("⚠️ LocalNotificationService.show failed: $e");
    }
  }

  /// Show appointment reminder notification
  static Future<void> showAppointmentReminder({
    required String doctorName,
    required String date,
    required String time,
  }) async {
    await show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Upcoming Appointment",
      body: "You have an appointment with Dr. $doctorName on $date at $time",
    );
  }

  /// Show appointment cancelled notification
  static Future<void> showAppointmentCancelled({
    required String doctorName,
  }) async {
    await show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Appointment Cancelled",
      body:
          "Your appointment with Dr. $doctorName has been cancelled.",
    );
  }

  /// Show payment confirmation notification
  static Future<void> showPaymentConfirmed({
    required String amount,
    required String doctorName,
  }) async {
    await show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Payment Confirmed ✅",
      body: "Payment of $amount EGP for Dr. $doctorName confirmed.",
    );
  }

  /// Show notifications from API response
  static Future<void> showFromApi(List<dynamic> notifications) async {
    for (int i = 0; i < notifications.length && i < 3; i++) {
      final n = notifications[i];
      if (n.isRead) continue; // only show unread
      await show(
        id: n.id,
        title: n.title.isNotEmpty ? n.title : "Notification",
        body: n.message,
      );
    }
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'core/services/local_notification_service.dart';
import 'healing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  // Initialize local notifications — requires full restart after first install
  try {
    await LocalNotificationService.init();
  } catch (e) {
    print("⚠️ LocalNotificationService init failed: $e");
  }
  runApp(const Healing());
}

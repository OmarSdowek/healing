import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/di/injection_container.dart';
import 'core/services/local_notification_service.dart';
import 'healing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe publishable key — test mode
  Stripe.publishableKey =
      'pk_test_51TFl4ODeG7x125FNYZqrHR7Z0VCAULr3YmQbPCw6gTYUsjziFwcYAbg6XMGxczGgAELAoalFe68Wg9SM96CE24J4002QFK4JS';

  await init();
  // Initialize local notifications — requires full restart after first install
  try {
    await LocalNotificationService.init();
  } catch (e) {
    print("⚠️ LocalNotificationService init failed: $e");
  }
  runApp(const Healing());
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'features/notifications/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize local notifications
  final notifications = LocalNotifications();
  await notifications.initialize();
  
  // Handle deep links when app is launched
  final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  
  runApp(
    ProviderScope(
      child: BloodlineSGApp(initialLink: initialLink),
    ),
  );
}
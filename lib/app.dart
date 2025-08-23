import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'core/theme/dexter_theme.dart';
import 'core/utils/deep_link_handler.dart';
import 'router.dart';

class BloodlineSGApp extends ConsumerStatefulWidget {
  final PendingDynamicLinkData? initialLink;
  
  const BloodlineSGApp({super.key, this.initialLink});

  @override
  ConsumerState<BloodlineSGApp> createState() => _BloodlineSGAppState();
}

class _BloodlineSGAppState extends ConsumerState<BloodlineSGApp> {
  late DeepLinkHandler _deepLinkHandler;

  @override
  void initState() {
    super.initState();
    _deepLinkHandler = DeepLinkHandler(ref);
    
    // Handle initial link if app was launched from deep link
    if (widget.initialLink != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _deepLinkHandler.handleDynamicLink(widget.initialLink!);
      });
    }
    
    // Listen for dynamic links while app is running
    FirebaseDynamicLinks.instance.onLink.listen(
      _deepLinkHandler.handleDynamicLink,
      onError: (error) {
        print('Dynamic link error: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '🩸 Bloodline SG',
      theme: DexterTheme.lightTheme,
      darkTheme: DexterTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

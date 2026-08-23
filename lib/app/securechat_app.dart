import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import '../features/design_system/design_tokens.dart';
import '../services/background/lifecycle_service.dart';
import 'router.dart';

class SecureChatApp extends StatefulWidget {
  const SecureChatApp({required this.lifecycle, super.key});

  final LifecycleService lifecycle;

  @override
  State<SecureChatApp> createState() => _SecureChatAppState();
}

class _SecureChatAppState extends State<SecureChatApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.lifecycle.update(state);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SecureChat X',
        debugShowCheckedModeBanner: false,
        theme: secureChatTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.home,
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );
}

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_scope.dart';
import 'environment.dart';
import '../features/design_system/foundation_widgets.dart';
import 'securechat_app.dart';

Future<void> bootstrapSecureChat({AppEnvironment? environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppEnvironment resolvedEnvironment = environment ?? AppEnvironment.fromDartDefines(
    name: const String.fromEnvironment('SECURECHAT_ENV', defaultValue: 'development'),
    protocolVersion: const String.fromEnvironment('SECURECHAT_PROTOCOL_VERSION', defaultValue: '1'),
  );
  ErrorWidget.builder = (_) => const ErrorState(
    message: 'Something unexpected occurred. Please restart the application.',
  );
  FlutterError.onError = (_) {};
  runZonedGuarded(
    () => runApp(AppScope(environment: resolvedEnvironment, child: const SecureChatApp())),
    (_, __) {}, // Intentionally suppress uncaught app data until a redacted reporter exists.
  );
}

import 'package:flutter/widgets.dart';

import 'environment.dart';
import '../core/errors/diagnostics.dart';

final class AppScope extends InheritedWidget {
  const AppScope({
    required this.environment,
    required this.diagnostics,
    required super.child,
    super.key,
  });
  final AppEnvironment environment;
  final DiagnosticsReporter diagnostics;

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      environment != oldWidget.environment || diagnostics != oldWidget.diagnostics;
}

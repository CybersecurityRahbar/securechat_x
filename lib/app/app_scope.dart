import 'package:flutter/widgets.dart';

import '../core/errors/diagnostics.dart';
import 'app_dependencies.dart';
import 'environment.dart';

final class AppScope extends InheritedWidget {
  const AppScope({
    required this.environment,
    required this.dependencies,
    required this.diagnostics,
    required super.child,
    super.key,
  });

  final AppEnvironment environment;
  final AppDependencies dependencies;
  final DiagnosticsReporter diagnostics;

  static AppScope of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null,
        'AppScope must be an ancestor of the requested context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      environment != oldWidget.environment ||
      dependencies != oldWidget.dependencies ||
      diagnostics != oldWidget.diagnostics;
}

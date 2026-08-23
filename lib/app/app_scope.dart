import 'package:flutter/widgets.dart';

import 'environment.dart';

final class AppScope extends InheritedWidget {
  const AppScope({required this.environment, required super.child, super.key});
  final AppEnvironment environment;

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope oldWidget) => environment != oldWidget.environment;
}

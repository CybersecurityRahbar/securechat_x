import 'package:flutter/material.dart';

import '../domain/entities/foundation_destination.dart';
import '../features/foundation/foundation_screen.dart';

final class AppRouter {
  const AppRouter._();

  static const String home = '/';
  static const Map<FoundationDestination, String> paths = {
    FoundationDestination.home: home,
    FoundationDestination.chats: '/chats',
    FoundationDestination.contacts: '/contacts',
    FoundationDestination.calls: '/calls',
    FoundationDestination.security: '/security',
    FoundationDestination.settings: '/settings',
  };

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final FoundationDestination destination = paths.entries
        .where((MapEntry<FoundationDestination, String> entry) => entry.value == settings.name)
        .map((MapEntry<FoundationDestination, String> entry) => entry.key)
        .firstOrNull ?? FoundationDestination.home;
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => FoundationScreen(destination: destination),
    );
  }
}

extension IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

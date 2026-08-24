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
    FoundationDestination.devices: '/devices',
    FoundationDestination.security: '/security',
    FoundationDestination.settings: '/settings',
  };

  static String pathFor(FoundationDestination destination) {
    final String? path = paths[destination];
    if (path == null) {
      throw StateError('No route is registered for foundation destination.');
    }
    return path;
  }

  static Route<void> onGenerateRoute(RouteSettings settings) {
    final FoundationDestination destination = _destinationForPath(
      settings.name,
    );
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => FoundationScreen(destination: destination),
    );
  }

  static FoundationDestination _destinationForPath(String? path) {
    for (final MapEntry<FoundationDestination, String> entry in paths.entries) {
      if (entry.value == path) return entry.key;
    }
    return FoundationDestination.home;
  }
}

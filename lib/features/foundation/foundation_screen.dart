import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../domain/entities/foundation_destination.dart';
import '../design_system/adaptive_navigation.dart';
import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/responsive.dart';
import '../home/secure_command_center.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({required this.destination, super.key});

  final FoundationDestination destination;

  static const Map<FoundationDestination, ({String title, IconData icon})>
      _items = {
    FoundationDestination.home: (
      title: 'Command Center',
      icon: SecureChatIcons.home,
    ),
    FoundationDestination.chats: (
      title: 'Chats',
      icon: SecureChatIcons.chats,
    ),
    FoundationDestination.contacts: (
      title: 'Contacts',
      icon: SecureChatIcons.contacts,
    ),
    FoundationDestination.calls: (
      title: 'Calls',
      icon: SecureChatIcons.calls,
    ),
    FoundationDestination.security: (
      title: 'Security Center',
      icon: SecureChatIcons.security,
    ),
    FoundationDestination.settings: (
      title: 'Settings',
      icon: SecureChatIcons.settings,
    ),
  };

  void _navigate(BuildContext context, FoundationDestination next) {
    if (next == destination) return;
    Navigator.of(context).pushReplacementNamed(AppRouter.pathFor(next));
  }

  @override
  Widget build(BuildContext context) {
    final ({String title, IconData icon}) item = _items[destination]!;
    final List<NavigationDestination> destinations =
        FoundationDestination.values.map((FoundationDestination value) {
      final ({String title, IconData icon}) data = _items[value]!;
      return NavigationDestination(
        icon: Icon(data.icon),
        selectedIcon: Icon(data.icon),
        label: data.title,
      );
    }).toList(growable: false);

    return SecureChatAdaptiveNavigation(
      title: 'SecureChat X',
      selectedIndex: FoundationDestination.values.indexOf(destination),
      onDestinationSelected: (int index) =>
          _navigate(context, FoundationDestination.values[index]),
      destinations: destinations,
      actions: [
        const SecureChatIconButton(
          icon: SecureChatIcons.search,
          label: 'Global search',
          onPressed: null,
        ),
        SecureChatIconButton(
          icon: Icons.info_outline,
          label: 'Foundation information',
          onPressed: () => showSecureChatDialog<void>(
            context,
            child: const Text(
              'SecureChat X 2.0 design-system phase. Features marked not implemented are not security claims.',
            ),
          ),
        ),
      ],
      child: _content(context, item),
    );
  }

  Widget _content(
    BuildContext context,
    ({String title, IconData icon}) item,
  ) {
    if (destination == FoundationDestination.home) {
      return const SecureCommandCenter();
    }

    return SafeArea(
      child: SecureChatConstrained(
        maxWidth: SecureChatContentConstraints.narrow,
        child: Padding(
          padding: SecureChatResponsiveInsets.page(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                key: const Key('foundation-screen-title'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SecureChatSpace.lg),
              SecureChatSurface(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: SecureChatColors.primary),
                    const SizedBox(width: SecureChatSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SecurityStatusIndicator(
                            status: SecurityStatus.notImplemented,
                          ),
                          const SizedBox(height: SecureChatSpace.md),
                          Text(
                            _detail(destination),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _detail(FoundationDestination value) => switch (value) {
        FoundationDestination.chats =>
          'Messaging is not implemented. No conversations or message content are available yet.',
        FoundationDestination.contacts =>
          'Contact identity and verification are not implemented yet.',
        FoundationDestination.calls =>
          'Calling and call signalling are not implemented yet.',
        FoundationDestination.security =>
          'Security state will be available after identity, storage, and protocol phases are implemented.',
        FoundationDestination.settings =>
          'Settings are intentionally unavailable until persistent, actionable settings are implemented.',
        FoundationDestination.home => 'The command center is available.',
      };
}

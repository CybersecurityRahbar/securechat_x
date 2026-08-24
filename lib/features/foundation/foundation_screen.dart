import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../domain/entities/foundation_destination.dart';
import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/responsive.dart';
import '../home/secure_command_center.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({required this.destination, super.key});

  final FoundationDestination destination;

  static const Map<FoundationDestination, ({String title, IconData icon})> _items = {
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
    final bool compact = SecureChatBreakpoints.isCompact(context);
    final ({String title, IconData icon}) item = _items[destination]!;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: compact ? SecureChatSpace.md : SecureChatSpace.lg,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: SecureChatColors.surfaceRaised,
                borderRadius: SecureChatRadii.small,
              ),
              child: const Icon(Icons.shield_rounded, size: 18, color: SecureChatColors.primary),
            ),
            const SizedBox(width: SecureChatSpace.sm),
            const Text('SecureChat X'),
          ],
        ),
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
          const SizedBox(width: SecureChatSpace.sm),
        ],
      ),
      body: Row(
        children: [
          if (!compact)
            NavigationRail(
              extended: SecureChatBreakpoints.isExpanded(context),
              selectedIndex: FoundationDestination.values.indexOf(destination),
              onDestinationSelected: (int index) =>
                  _navigate(context, FoundationDestination.values[index]),
              leading: const Padding(
                padding: EdgeInsets.only(bottom: SecureChatSpace.md),
                child: SecurityStatusIndicator(
                  status: SecurityStatus.notImplemented,
                ),
              ),
              destinations: FoundationDestination.values.map((FoundationDestination value) {
                final ({String title, IconData icon}) data = _items[value]!;
                return NavigationRailDestination(
                  icon: Icon(data.icon),
                  selectedIcon: Icon(data.icon),
                  label: Text(data.title),
                );
              }).toList(),
            ),
          Expanded(child: _content(context, item)),
        ],
      ),
      bottomNavigationBar: compact
          ? NavigationBar(
              selectedIndex: FoundationDestination.values.indexOf(destination),
              onDestinationSelected: (int index) =>
                  _navigate(context, FoundationDestination.values[index]),
              destinations: FoundationDestination.values.map((FoundationDestination value) {
                final ({String title, IconData icon}) data = _items[value]!;
                return NavigationDestination(icon: Icon(data.icon), label: data.title);
              }).toList(),
            )
          : null,
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
              SecureChatCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: SecureChatColors.primary),
                    const SizedBox(width: SecureChatSpace.md),
                    Expanded(
                      child: EmptyState(
                        title: item.title,
                        message: _detail(destination),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SecurityStatusIndicator(status: SecurityStatus.notImplemented),
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

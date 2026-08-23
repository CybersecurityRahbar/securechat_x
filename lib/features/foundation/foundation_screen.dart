import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../domain/entities/foundation_destination.dart';
import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({required this.destination, super.key});
  final FoundationDestination destination;

  static const Map<FoundationDestination, ({String title, String detail, IconData icon})> _content = {
    FoundationDestination.home: (
      title: 'Command Center',
      detail: 'Foundation status and operational context will be assembled here in Phase 2.',
      icon: SecureChatIcons.home,
    ),
    FoundationDestination.chats: (
      title: 'Chats',
      detail: 'Messaging is not implemented. No conversations or message content are available yet.',
      icon: SecureChatIcons.chats,
    ),
    FoundationDestination.contacts: (
      title: 'Contacts',
      detail: 'Contact identity and verification are not implemented yet.',
      icon: SecureChatIcons.contacts,
    ),
    FoundationDestination.calls: (
      title: 'Calls',
      detail: 'Calling and call signalling are not implemented yet.',
      icon: SecureChatIcons.calls,
    ),
    FoundationDestination.security: (
      title: 'Security Center',
      detail: 'Security state will be available after identity, storage, and protocol phases are implemented.',
      icon: SecureChatIcons.security,
    ),
    FoundationDestination.settings: (
      title: 'Settings',
      detail: 'Settings are intentionally unavailable until persistent, actionable settings are implemented.',
      icon: SecureChatIcons.settings,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final ({String title, String detail, IconData icon}) content = _content[destination]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SecureChat X'),
        actions: [
          SecureChatIconButton(
            icon: Icons.info_outline,
            label: 'Foundation information',
            onPressed: () => showSecureChatDialog<void>(
              context,
              child: const Text(
                'SecureChat X 2.0 foundation. Features marked not implemented are not security claims.',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SecureChatSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: SecureChatSpace.md),
              SecureChatCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(content.icon, color: SecureChatColors.primary),
                    const SizedBox(width: SecureChatSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(content.detail),
                          const SizedBox(height: SecureChatSpace.md),
                          const SecurityStatusIndicator(status: SecurityStatus.notImplemented),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: EmptyState(
                  title: 'No local data yet',
                  message: 'This area will receive data only after its supporting security and persistence foundations are implemented.',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: FoundationDestination.values.indexOf(destination),
        onDestinationSelected: (int index) {
          final FoundationDestination next = FoundationDestination.values[index];
          Navigator.of(context).pushReplacementNamed(AppRouter.pathFor(next));
        },
        destinations: FoundationDestination.values.map((FoundationDestination item) {
          final ({String title, String detail, IconData icon}) value = _content[item]!;
          return NavigationDestination(icon: Icon(value.icon), label: value.title);
        }).toList(),
      ),
    );
  }
}

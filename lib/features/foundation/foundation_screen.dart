import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../domain/entities/foundation_destination.dart';
import '../contacts/contacts_screen.dart';
import '../design_system/adaptive_navigation.dart';
import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/responsive.dart';
import '../devices/devices_screen.dart';
import '../home/secure_command_center.dart';
import '../messaging/chats_screen.dart';
import '../security/security_center_screen.dart';
import '../settings/settings_screen.dart';

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
    FoundationDestination.devices: (
      title: 'Devices',
      icon: SecureChatIcons.devices,
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
              'SecureChat X 2.0 presentation layer. Features marked not implemented are not security claims.',
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
    switch (destination) {
      case FoundationDestination.home:
        return const SecureCommandCenter();
      case FoundationDestination.chats:
        return const ChatsScreen();
      case FoundationDestination.contacts:
        return const ContactsScreen();
      case FoundationDestination.devices:
        return const DevicesScreen();
      case FoundationDestination.security:
        return const SecurityCenterScreen();
      case FoundationDestination.settings:
        return const SettingsScreen();
      case FoundationDestination.calls:
        return _placeholder(context, item);
    }
  }

  Widget _placeholder(
    BuildContext context,
    ({String title, IconData icon}) item,
  ) {
    return SafeArea(
      child: SecureChatConstrained(
        maxWidth: SecureChatContentConstraints.narrow,
        child: SingleChildScrollView(
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
              SecureChatFeatureBanner(
                title: 'Calls are not implemented',
                message:
                    'The presentation shell is ready for the future call state machine, signalling contract and media controls. No call security capability is claimed here.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

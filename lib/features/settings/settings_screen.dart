import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/responsive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SecureChatConstrained(
          maxWidth: SecureChatContentConstraints.wide,
          child: SingleChildScrollView(
            padding: SecureChatResponsiveInsets.page(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SecureChatSectionHeader(
                  title: 'Settings',
                  subtitle:
                      'Privacy, security, network, storage and accessibility',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                const SecureChatFeaturePanel(),
                const SizedBox(height: SecureChatSpace.md),
                const _SettingsSection(
                  title: 'Privacy',
                  icon: Icons.visibility_outlined,
                  items: <String>[
                    'Online status',
                    'Last seen',
                    'Read receipts',
                    'Typing indicators',
                    'Message previews',
                    'Link previews',
                    'Contact discovery',
                    'Media auto-download',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                const _SettingsSection(
                  title: 'Security',
                  icon: SecureChatIcons.security,
                  items: <String>[
                    'App lock',
                    'Biometrics',
                    'Lock timeout',
                    'Lock on background',
                    'Screen capture protection',
                    'Security alerts',
                    'Device management',
                    'Session management',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                const _SettingsSection(
                  title: 'Network and transfers',
                  icon: Icons.wifi_outlined,
                  items: <String>[
                    'Connection center',
                    'Wi-Fi/mobile transfer policy',
                    'Background sync',
                    'Transfer concurrency',
                    'Call network preference',
                    'Diagnostics',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                const _SettingsSection(
                  title: 'Notifications and calls',
                  icon: Icons.notifications_none_outlined,
                  items: <String>[
                    'Notification preview mode',
                    'Per-conversation notifications',
                    'Group notifications',
                    'Call notifications',
                    'Silent notifications',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                const _SettingsSection(
                  title: 'Storage and data',
                  icon: Icons.storage_outlined,
                  items: <String>[
                    'Storage center',
                    'Media cache',
                    'Encrypted attachment cache',
                    'Temporary files',
                    'Drafts',
                    'Cleanup opportunities',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                const _SettingsSection(
                  title: 'Accessibility and appearance',
                  icon: Icons.accessibility_new_outlined,
                  items: <String>[
                    'Reduced motion',
                    'Text size',
                    'Contrast preferences',
                    'Appearance',
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class SecureChatFeaturePanel extends StatelessWidget {
  const SecureChatFeaturePanel({super.key});

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.tune_outlined, color: SecureChatColors.primary),
            SizedBox(width: SecureChatSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings are not yet actionable'),
                  SizedBox(height: SecureChatSpace.xs),
                  Text(
                    'Controls are presented as the final information architecture. No inactive switch is presented as a working security control.',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<String> items;

  @override
  Widget build(BuildContext context) => SecureChatSurface(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SecureChatSpace.md,
                SecureChatSpace.md,
                SecureChatSpace.md,
                SecureChatSpace.sm,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: SecureChatColors.primary),
                  const SizedBox(width: SecureChatSpace.sm),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            for (final String item in items) ...[
              ListTile(
                title: Text(item),
                subtitle: const Text('Not implemented'),
                trailing: const SecurityStatusIndicator(
                  status: SecurityStatus.notImplemented,
                ),
                onTap: () => showSecureChatDialog<void>(
                  context,
                  child: Text(
                    '$item is not implemented yet. It will become actionable only when its supporting phase is complete.',
                  ),
                ),
              ),
              if (item != items.last) const Divider(height: 1),
            ],
          ],
        ),
      );
}

import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/responsive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SecureChatConstrained(
          maxWidth: SecureChatContentConstraints.wide,
          child: Padding(
            padding: SecureChatResponsiveInsets.page(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SecureChatSectionHeader(
                  title: 'Settings',
                  subtitle: 'Presentation foundation for actionable settings',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                const SecureChatFeaturePanel(),
                const SizedBox(height: SecureChatSpace.md),
                _SettingsSection(
                  title: 'Privacy',
                  items: const [
                    'Online status',
                    'Read receipts',
                    'Message previews',
                    'Link previews',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                _SettingsSection(
                  title: 'Security',
                  items: const [
                    'App lock',
                    'Biometrics',
                    'Screen protection',
                    'Security alerts',
                  ],
                ),
                const SizedBox(height: SecureChatSpace.md),
                _SettingsSection(
                  title: 'Accessibility and appearance',
                  items: const [
                    'Reduced motion',
                    'Text size',
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
                    'Controls are shown to establish the final information architecture. No inactive switch is presented as a working security control.',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.items});

  final String title;
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
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
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
                  child: Text('$item is not implemented yet.'),
                ),
              ),
              if (item != items.last) const Divider(height: 1),
            ],
          ],
        ),
      );
}

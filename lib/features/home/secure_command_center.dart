import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/responsive.dart';

class SecureCommandCenter extends StatelessWidget {
  const SecureCommandCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = SecureChatResponsiveInsets.page(context);
    return SingleChildScrollView(
      padding: padding,
      child: SecureChatConstrained(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CommandHeader(),
            const SizedBox(height: SecureChatSpace.lg),
            const _SecurityOverview(),
            const SizedBox(height: SecureChatSpace.lg),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool stacked = constraints.maxWidth < 760;
                if (stacked) {
                  return const Column(
                    children: [
                      _OperationalCard(),
                      SizedBox(height: SecureChatSpace.md),
                      _QuickActionsCard(),
                    ],
                  );
                }
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _OperationalCard()),
                    SizedBox(width: SecureChatSpace.md),
                    Expanded(child: _QuickActionsCard()),
                  ],
                );
              },
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const _RecentSignalsCard(),
          ],
        ),
      ),
    );
  }
}

class _CommandHeader extends StatelessWidget {
  const _CommandHeader();

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Command Center',
                  key: const Key('foundation-screen-title'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: SecureChatSpace.sm),
                Text(
                  'A high-level view of SecureChat X system state. '
                  'Live security capabilities are introduced only when their foundations are implemented.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(width: SecureChatSpace.md),
          const SecureChatIconButton(
            icon: SecureChatIcons.search,
            label: 'Global search',
            onPressed: null,
          ),
        ],
      );
}

class _SecurityOverview extends StatelessWidget {
  const _SecurityOverview();

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(SecureChatSpace.lg),
          child: Wrap(
            runSpacing: SecureChatSpace.md,
            spacing: SecureChatSpace.xl,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const SizedBox(
                width: 260,
                child: _StatusBlock(
                  icon: SecureChatIcons.alert,
                  title: 'Foundation status',
                  value: 'Phase 2 in progress',
                  color: SecureChatColors.primary,
                ),
              ),
              const _StatusBlock(
                icon: SecureChatIcons.devices,
                title: 'Identity',
                value: 'Not implemented',
                color: SecureChatColors.neutral,
              ),
              const _StatusBlock(
                icon: SecureChatIcons.security,
                title: 'Secure sessions',
                value: 'Not implemented',
                color: SecureChatColors.neutral,
              ),
              const _StatusBlock(
                icon: SecureChatIcons.transfer,
                title: 'Transfers',
                value: 'No active transfers',
                color: SecureChatColors.neutral,
              ),
            ],
          ),
        ),
      );
}

class _StatusBlock extends StatelessWidget {
  const _StatusBlock({required this.icon, required this.title, required this.value, required this.color});

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: SecureChatSpace.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ],
      );
}

class _OperationalCard extends StatelessWidget {
  const _OperationalCard();

  @override
  Widget build(BuildContext context) => SecureChatCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(SecureChatIcons.activity, color: SecureChatColors.primary),
                const SizedBox(width: SecureChatSpace.sm),
                Text('Operational state', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const _StateLine(label: 'Local persistence', value: 'Foundation only'),
            const _StateLine(label: 'Network transport', value: 'Interface only'),
            const _StateLine(label: 'Cryptographic engine', value: 'Interface only'),
            const _StateLine(label: 'Diagnostics', value: 'Redacted boundary active'),
          ],
        ),
      );
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) => SecureChatCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt_rounded, color: SecureChatColors.primary),
                const SizedBox(width: SecureChatSpace.sm),
                Text('Quick actions', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: SecureChatSpace.lg),
            Wrap(
              spacing: SecureChatSpace.sm,
              runSpacing: SecureChatSpace.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(SecureChatIcons.chats),
                  label: const Text('New chat'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(SecureChatIcons.devices),
                  label: const Text('Devices'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(SecureChatIcons.security),
                  label: const Text('Security'),
                ),
              ],
            ),
            const SizedBox(height: SecureChatSpace.md),
            Text(
              'Actions become active only when their supporting feature is implemented.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}

class _RecentSignalsCard extends StatelessWidget {
  const _RecentSignalsCard();

  @override
  Widget build(BuildContext context) => SecureChatCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent signals', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: SecureChatSpace.md),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('Phase 1 foundation validated'),
              subtitle: Text('Analysis, tests and Android debug build are passing in CI.'),
            ),
            const Divider(height: SecureChatSpace.lg),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(SecureChatIcons.security),
              title: Text('Security capabilities are explicitly unimplemented'),
              subtitle: Text('No E2EE, identity or verification claim is active yet.'),
            ),
          ],
        ),
      );
}

class _StateLine extends StatelessWidget {
  const _StateLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: SecureChatSpace.sm),
        child: Row(
          children: [
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
            Text(value, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      );
}

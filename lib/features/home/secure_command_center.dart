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
          children: const [
            _CommandHeader(),
            SizedBox(height: SecureChatSpace.lg),
            _SecurityOverview(),
            SizedBox(height: SecureChatSpace.lg),
            _OperationalGrid(),
            SizedBox(height: SecureChatSpace.lg),
            _RecentSignalsCard(),
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
                  'A high-level view of SecureChat X system state. Live security capabilities appear only after their supporting phases are implemented.',
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
  Widget build(BuildContext context) => SecureChatSurface(
        padding: const EdgeInsets.all(SecureChatSpace.lg),
        child: Wrap(
          runSpacing: SecureChatSpace.lg,
          spacing: SecureChatSpace.xl,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            SecureChatMetric(
              icon: SecureChatIcons.alert,
              label: 'Foundation status',
              value: 'Phase 2 in progress',
              accentColor: SecureChatColors.primary,
            ),
            SecureChatMetric(
              icon: SecureChatIcons.devices,
              label: 'Identity',
              value: 'Not implemented',
            ),
            SecureChatMetric(
              icon: SecureChatIcons.security,
              label: 'Secure sessions',
              value: 'Not implemented',
            ),
            SecureChatMetric(
              icon: SecureChatIcons.transfer,
              label: 'Transfers',
              value: 'No active transfers',
            ),
          ],
        ),
      );
}

class _OperationalGrid extends StatelessWidget {
  const _OperationalGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
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
      );
}

class _OperationalCard extends StatelessWidget {
  const _OperationalCard();

  @override
  Widget build(BuildContext context) => SecureChatCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecureChatSectionHeader(
              title: 'Operational state',
              subtitle: 'Current foundation boundaries',
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const _StateLine(
                label: 'Local persistence', value: 'Foundation only'),
            const _StateLine(
                label: 'Network transport', value: 'Interface only'),
            const _StateLine(
                label: 'Cryptographic engine', value: 'Interface only'),
            const _StateLine(
                label: 'Diagnostics', value: 'Redacted boundary active'),
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
            const SecureChatSectionHeader(
              title: 'Quick actions',
              subtitle: 'Available after supporting phases are implemented',
            ),
            const SizedBox(height: SecureChatSpace.lg),
            Wrap(
              spacing: SecureChatSpace.sm,
              runSpacing: SecureChatSpace.sm,
              children: const [
                OutlinedButton.icon(
                  onPressed: null,
                  icon: Icon(SecureChatIcons.chats),
                  label: Text('New chat'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: Icon(SecureChatIcons.devices),
                  label: Text('Devices'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: Icon(SecureChatIcons.security),
                  label: Text('Security'),
                ),
              ],
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
            const SecureChatSectionHeader(
              title: 'Recent signals',
              subtitle: 'Development and security-state context',
            ),
            const SizedBox(height: SecureChatSpace.md),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.check_circle_outline,
                  color: SecureChatColors.success),
              title: Text('Phase 1 foundation validated'),
              subtitle: Text(
                  'Analysis, tests and Android debug build are passing in CI.'),
            ),
            const Divider(height: SecureChatSpace.lg),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(SecureChatIcons.security),
              title: Text('Security capabilities are not active'),
              subtitle: Text(
                  'No E2EE, identity or verification claim is active yet.'),
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
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: SecureChatSpace.md),
            SecureChatStatusPill(label: value),
          ],
        ),
      );
}

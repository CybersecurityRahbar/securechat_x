import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/responsive.dart';

class SecurityCenterScreen extends StatelessWidget {
  const SecurityCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool expanded = SecureChatBreakpoints.isExpanded(context);

    return SafeArea(
      child: SecureChatConstrained(
        maxWidth: SecureChatContentConstraints.wide,
        child: SingleChildScrollView(
          padding: SecureChatResponsiveInsets.page(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SecureChatSectionHeader(
                title: 'Security Center',
                subtitle: 'Security state, audit and remediation presentation',
              ),
              const SizedBox(height: SecureChatSpace.lg),
              const _SecurityOverviewCard(),
              const SizedBox(height: SecureChatSpace.md),
              GridView.builder(
                itemCount: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: expanded ? 2 : 1,
                  mainAxisSpacing: SecureChatSpace.md,
                  crossAxisSpacing: SecureChatSpace.md,
                  mainAxisExtent: expanded ? 116 : 142,
                ),
                itemBuilder: (BuildContext context, int index) {
                  const items =
                      <({IconData icon, String title, String detail})>[
                    (
                      icon: SecureChatIcons.contacts,
                      title: 'Identity',
                      detail: 'Identity verification is not implemented.',
                    ),
                    (
                      icon: SecureChatIcons.devices,
                      title: 'Devices',
                      detail:
                          'Device trust and revocation are not implemented.',
                    ),
                    (
                      icon: SecureChatIcons.security,
                      title: 'Sessions',
                      detail: 'Session health is not implemented.',
                    ),
                    (
                      icon: Icons.storage_outlined,
                      title: 'Local data',
                      detail: 'Protected database state is not implemented.',
                    ),
                    (
                      icon: Icons.vpn_key_outlined,
                      title: 'Prekeys',
                      detail: 'Prekey lifecycle is not implemented.',
                    ),
                    (
                      icon: Icons.restore_outlined,
                      title: 'Recovery',
                      detail: 'Recovery state is not implemented.',
                    ),
                  ];
                  final item = items[index];
                  return _SecurityCheckTile(item: item);
                },
              ),
              const SizedBox(height: SecureChatSpace.md),
              const _SecurityEventsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityOverviewCard extends StatelessWidget {
  const _SecurityOverviewCard();

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
        padding: EdgeInsets.all(SecureChatSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SecurityStatusIndicator(
                  status: SecurityStatus.notImplemented,
                ),
                SizedBox(width: SecureChatSpace.sm),
                Expanded(
                  child: Text('Security audit engine is not implemented.'),
                ),
              ],
            ),
            SizedBox(height: SecureChatSpace.md),
            Text(
              'This dashboard is the presentation foundation for identity, device, session, local-data, prekey and recovery checks. It does not claim that any of those protections are active.',
            ),
            SizedBox(height: SecureChatSpace.md),
            Row(
              children: [
                Icon(Icons.schedule_outlined, size: 18),
                SizedBox(width: SecureChatSpace.sm),
                Text('Last audit: not available'),
              ],
            ),
          ],
        ),
      );
}

class _SecurityCheckTile extends StatelessWidget {
  const _SecurityCheckTile({required this.item});

  final ({IconData icon, String title, String detail}) item;

  @override
  Widget build(BuildContext context) => SecureChatSurface(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(item.icon, color: SecureChatColors.muted),
            const SizedBox(width: SecureChatSpace.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: SecureChatSpace.sm),
                      const SecurityStatusIndicator(
                        status: SecurityStatus.notImplemented,
                      ),
                    ],
                  ),
                  const SizedBox(height: SecureChatSpace.xs),
                  Text(
                    item.detail,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SecurityEventsCard extends StatelessWidget {
  const _SecurityEventsCard();

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecureChatSectionHeader(
              title: 'Security events',
              subtitle: 'Future audit history and actionable warnings',
            ),
            SizedBox(height: SecureChatSpace.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('No security events are recorded'),
              subtitle: Text(
                'Persistent security-event history will be implemented with the database and security-audit phases.',
              ),
            ),
          ],
        ),
      );
}

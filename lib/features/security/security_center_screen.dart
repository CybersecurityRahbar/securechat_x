import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/responsive.dart';

class SecurityCenterScreen extends StatelessWidget {
  const SecurityCenterScreen({super.key});

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
                  title: 'Security Center',
                  subtitle: 'Security state presentation foundation',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                const SecureChatSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SecurityStatusIndicator(
                        status: SecurityStatus.notImplemented,
                      ),
                      SizedBox(height: SecureChatSpace.md),
                      Text('Security audit engine is not implemented.'),
                    ],
                  ),
                ),
                const SizedBox(height: SecureChatSpace.lg),
                GridView.count(
                  crossAxisCount: MediaQuery.sizeOf(context).width >= 840 ? 2 : 1,
                  mainAxisSpacing: SecureChatSpace.md,
                  crossAxisSpacing: SecureChatSpace.md,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3.5,
                  children: const [
                    _SecurityCheckTile(
                      title: 'Identity',
                      detail: 'Identity verification is not implemented.',
                    ),
                    _SecurityCheckTile(
                      title: 'Devices',
                      detail: 'Device trust is not implemented.',
                    ),
                    _SecurityCheckTile(
                      title: 'Sessions',
                      detail: 'Session health is not implemented.',
                    ),
                    _SecurityCheckTile(
                      title: 'Local data',
                      detail: 'Protected database state is not implemented.',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _SecurityCheckTile extends StatelessWidget {
  const _SecurityCheckTile({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => SecureChatSurface(
        child: Row(
          children: [
            const SecurityStatusIndicator(
              status: SecurityStatus.notImplemented,
            ),
            const SizedBox(width: SecureChatSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: SecureChatSpace.xs),
                  Text(detail, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      );
}

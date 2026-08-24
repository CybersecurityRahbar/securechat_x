import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/responsive.dart';

class SecurityCenterScreen extends StatelessWidget {
  const SecurityCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool expanded = width >= SecureChatBreakpoints.medium;

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
              GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: expanded ? 2 : 1,
                  mainAxisSpacing: SecureChatSpace.md,
                  crossAxisSpacing: SecureChatSpace.md,
                  mainAxisExtent: expanded ? 112 : 132,
                ),
                itemBuilder: (BuildContext context, int index) {
                  const items = <({String title, String detail})>[
                    (
                      title: 'Identity',
                      detail: 'Identity verification is not implemented.',
                    ),
                    (
                      title: 'Devices',
                      detail: 'Device trust is not implemented.',
                    ),
                    (
                      title: 'Sessions',
                      detail: 'Session health is not implemented.',
                    ),
                    (
                      title: 'Local data',
                      detail: 'Protected database state is not implemented.',
                    ),
                  ];
                  final item = items[index];
                  return _SecurityCheckTile(
                    title: item.title,
                    detail: item.detail,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityCheckTile extends StatelessWidget {
  const _SecurityCheckTile({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => SecureChatSurface(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SecurityStatusIndicator(
              status: SecurityStatus.notImplemented,
            ),
            const SizedBox(width: SecureChatSpace.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: SecureChatSpace.xs),
                  Text(
                    detail,
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

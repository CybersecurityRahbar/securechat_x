import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/responsive.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

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
              title: 'Devices',
              subtitle: 'Linked-device trust and session presentation',
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const SecureChatFeatureBanner(
              title: 'Device identity is not implemented',
              message:
                  'Each device will later have independent cryptographic material, trust state, session state and revocation lifecycle. No device is presented as verified in this phase.',
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const _CurrentDeviceCard(),
            const SizedBox(height: SecureChatSpace.md),
            _LinkedDevicesCard(onAction: () => _showUnavailable(context)),
            const SizedBox(height: SecureChatSpace.md),
            const _DeviceSecurityCard(),
          ],
        ),
      ),
    ),
  );

  static Future<void> _showUnavailable(
    BuildContext context,
  ) => showSecureChatDialog<void>(
    context,
    child: const Text(
      'Device registration, secure linking and revocation require the identity and secure-storage phases.',
    ),
  );
}

class _CurrentDeviceCard extends StatelessWidget {
  const _CurrentDeviceCard();

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecureChatSectionHeader(
          title: 'Current device',
          subtitle: 'Local device presentation only',
        ),
        SizedBox(height: SecureChatSpace.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(SecureChatIcons.devices),
          title: Text('Primary Android device'),
          subtitle: Text('Device identity and trust state unavailable'),
          trailing: SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
        ),
        Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.key_outlined),
          title: Text('Key material'),
          subtitle: Text('Secure key lifecycle is not implemented.'),
        ),
      ],
    ),
  );
}

class _LinkedDevicesCard extends StatelessWidget {
  const _LinkedDevicesCard({required this.onAction});

  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => SecureChatSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SecureChatSectionHeader(
          title: 'Linked devices',
          subtitle: 'Multi-device architecture foundation',
        ),
        const SizedBox(height: SecureChatSpace.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.add_link_outlined),
          title: const Text('Link another device'),
          subtitle: const Text(
            'Secure device linking will become available after identity, key storage and recovery are implemented.',
          ),
          trailing: const SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
          onTap: onAction,
        ),
        const Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.block_outlined),
          title: const Text('Revoke a device'),
          subtitle: const Text(
            'Revocation requires an authenticated device and persistent device registry.',
          ),
          trailing: const SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
          onTap: onAction,
        ),
      ],
    ),
  );
}

class _DeviceSecurityCard extends StatelessWidget {
  const _DeviceSecurityCard();

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecureChatSectionHeader(
          title: 'Device security',
          subtitle: 'Future device health signals',
        ),
        SizedBox(height: SecureChatSpace.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.phonelink_lock_outlined),
          title: Text('Trust state'),
          subtitle: Text('Device trust is not established yet.'),
          trailing: SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
        ),
        Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.history_outlined),
          title: Text('Session history'),
          subtitle: Text(
            'Session inventory will follow the session-manager phase.',
          ),
        ),
      ],
    ),
  );
}

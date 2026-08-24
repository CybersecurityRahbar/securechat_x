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
                  subtitle: 'Linked-device presentation foundation',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                const SecureChatFeatureBanner(
                  title: 'Device identity is not implemented',
                  message:
                      'Each device will later have independent cryptographic material, trust state and revocation lifecycle. No device is presented as verified in this phase.',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                SecureChatSurface(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(SecureChatIcons.devices),
                        title: Text('Current device'),
                        subtitle: Text('Device identity unavailable'),
                        trailing: SecurityStatusIndicator(
                          status: SecurityStatus.notImplemented,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.add_link_outlined),
                        title: const Text('Link another device'),
                        subtitle: const Text(
                          'Device registration and secure linking are deferred to the identity phase.',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showSecureChatDialog<void>(
                          context,
                          child: const Text(
                            'Device linking is not available until identity and secure storage are implemented.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

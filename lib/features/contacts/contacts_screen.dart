import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/responsive.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

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
                  title: 'Contacts',
                  subtitle: 'Identity and verification workspace',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                const SecureChatFeatureBanner(
                  title: 'Identity verification not implemented',
                  message:
                      'Fingerprints, QR verification, device trust and identity-change handling will be implemented in the identity phase. This screen contains presentation structure only.',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                SecureChatSurface(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: SecureChatAvatar(label: 'Contact identity'),
                        title: Text('Contact identity preview'),
                        subtitle: Text('Verification state unavailable'),
                        trailing: SecurityStatusIndicator(
                          status: SecurityStatus.notImplemented,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.qr_code_2_outlined),
                        title: const Text('Verification'),
                        subtitle: const Text(
                          'QR and manual verification will become actionable after identity is implemented.',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showSecureChatDialog<void>(
                          context,
                          child: const Text(
                            'Verification is intentionally unavailable until the identity protocol is implemented and tested.',
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

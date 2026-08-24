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
      child: SingleChildScrollView(
        padding: SecureChatResponsiveInsets.page(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecureChatSectionHeader(
              title: 'Contacts',
              subtitle: 'Identity, trust and verification workspace',
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const SecureChatFeatureBanner(
              title: 'Identity verification is not implemented',
              message:
                  'Fingerprints, QR verification, device trust and identity-change handling will become actionable only after the identity and verification phases are complete.',
            ),
            const SizedBox(height: SecureChatSpace.lg),
            const _ContactIdentityCard(),
            const SizedBox(height: SecureChatSpace.md),
            _VerificationCard(onOpen: () => _showUnavailable(context)),
            const SizedBox(height: SecureChatSpace.md),
            const _TrustStateCard(),
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
      'Identity verification is intentionally unavailable until the identity protocol, secure storage and verification flow are implemented and tested.',
    ),
  );
}

class _ContactIdentityCard extends StatelessWidget {
  const _ContactIdentityCard();

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
    child: Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SecureChatAvatar(label: 'Contact identity'),
          title: Text('Contact identity preview'),
          subtitle: Text('Stable identity identifier unavailable'),
          trailing: SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
        ),
        Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(SecureChatIcons.security),
          title: Text('Identity fingerprint'),
          subtitle: Text('Fingerprint generation is not implemented.'),
        ),
      ],
    ),
  );
}

class _VerificationCard extends StatelessWidget {
  const _VerificationCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => SecureChatSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SecureChatSectionHeader(
          title: 'Verification',
          subtitle: 'Trust establishment presentation',
        ),
        const SizedBox(height: SecureChatSpace.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.qr_code_2_outlined),
          title: const Text('QR verification'),
          subtitle: const Text(
            'QR verification will compare the authenticated contact identity after the identity phase.',
          ),
          trailing: const SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
          onTap: onOpen,
        ),
        const Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.compare_arrows_outlined),
          title: const Text('Manual comparison'),
          subtitle: const Text(
            'Numeric/manual fingerprint comparison will be available after identity keys exist.',
          ),
          trailing: const SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
          onTap: onOpen,
        ),
      ],
    ),
  );
}

class _TrustStateCard extends StatelessWidget {
  const _TrustStateCard();

  @override
  Widget build(BuildContext context) => const SecureChatSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecureChatSectionHeader(
          title: 'Trust state',
          subtitle: 'Future identity-change and quarantine signals',
        ),
        SizedBox(height: SecureChatSpace.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.verified_user_outlined),
          title: Text('Verified state'),
          subtitle: Text('No contact is presented as verified in Phase 2.'),
          trailing: SecurityStatusIndicator(
            status: SecurityStatus.notImplemented,
          ),
        ),
        Divider(height: 1),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.warning_amber_outlined),
          title: Text('Identity change warning'),
          subtitle: Text(
            'Changed identities will require explicit verification before they can be trusted.',
          ),
        ),
      ],
    ),
  );
}

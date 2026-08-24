import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/motion_accessibility.dart';
import '../design_system/responsive.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          titleSpacing: SecureChatSpace.md,
          title: Row(
            children: [
              const SecureChatAvatar(label: 'Conversation identity', size: 36),
              const SizedBox(width: SecureChatSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conversation preview',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Identity and session state not available',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SecureChatSpace.sm),
              const SecurityStatusIndicator(
                status: SecurityStatus.notImplemented,
              ),
            ],
          ),
          actions: [
            SecureChatIconButton(
              icon: Icons.search_rounded,
              label: 'Search messages',
              onPressed: () => showSecureChatDialog<void>(
                context,
                child: const Text(
                  'Local message search will become available with the database and messaging engine phases.',
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: SecureChatResponsiveInsets.page(context),
                children: [
                  const SecureChatFeatureBanner(
                    title: 'Conversation preview only',
                    message:
                        'No real message content is stored, encrypted, sent, delivered, or read in this screen yet.',
                  ),
                  const SizedBox(height: SecureChatSpace.md),
                  SecureChatSurface(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SecureChatSpace.md,
                      vertical: SecureChatSpace.sm,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          SecureChatIcons.security,
                          color: SecureChatColors.neutral,
                          size: 18,
                        ),
                        const SizedBox(width: SecureChatSpace.sm),
                        Expanded(
                          child: Text(
                            'Secure session state is unavailable until the identity and session phases are implemented.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SecureChatSpace.lg),
                  const SecureChatMessageBubble(
                    message: 'Incoming message bubble preview',
                    timestamp: 'Preview',
                    statusLabel: 'UI only',
                  ),
                  const SecureChatMessageBubble(
                    message: 'Outgoing message layout preview',
                    timestamp: 'Preview',
                    isMine: true,
                    statusLabel: 'UI only',
                  ),
                  const SecureChatMessageBubble(
                    message:
                        'Longer message previews are intentionally constrained to test wrapping and accessibility on compact screens.',
                    timestamp: 'Preview',
                    statusLabel: 'Not implemented',
                  ),
                  SecureChatMotionAnimatedSecurityHint(
                    reducedMotionAware: true,
                  ),
                ],
              ),
            ),
            const SecureChatComposer(onSend: null, enabled: false),
          ],
        ),
      );
}

class SecureChatMotionAnimatedSecurityHint extends StatelessWidget {
  const SecureChatMotionAnimatedSecurityHint({
    super.key,
    this.reducedMotionAware = true,
  });

  final bool reducedMotionAware;

  @override
  Widget build(BuildContext context) {
    final Widget child = const Padding(
      padding: EdgeInsets.only(top: SecureChatSpace.sm),
      child: SizedBox(
        height: 1,
        child: ColoredBox(color: SecureChatColors.divider),
      ),
    );

    if (!reducedMotionAware) return child;

    return SecureChatAnimatedSwitcher(
      child: KeyedSubtree(
        key: ValueKey<bool>(MediaQuery.of(context).disableAnimations),
        child: child,
      ),
    );
  }
}

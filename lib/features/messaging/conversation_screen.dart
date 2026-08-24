import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
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
                    ),
                    Text(
                      'Identity and session state not available',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SecurityStatusIndicator(
                status: SecurityStatus.notImplemented,
              ),
            ],
          ),
          actions: [
            SecureChatIconButton(
              icon: Icons.search_rounded,
              label: 'Search messages',
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: SecureChatResponsiveInsets.page(context),
                children: const [
                  SecureChatFeatureBanner(
                    title: 'Conversation preview only',
                    message:
                        'No real message content is stored, encrypted, sent, delivered, or read in this screen yet.',
                  ),
                  SizedBox(height: SecureChatSpace.lg),
                  SecureChatMessageBubble(
                    message: 'Message bubble preview',
                    timestamp: 'Preview',
                    statusLabel: 'UI only',
                  ),
                  SecureChatMessageBubble(
                    message: 'Outgoing message layout preview',
                    timestamp: 'Preview',
                    isMine: true,
                    statusLabel: 'UI only',
                  ),
                ],
              ),
            ),
            const SecureChatComposer(onSend: null, enabled: false),
          ],
        ),
      );
}

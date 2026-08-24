import 'package:flutter/material.dart';

import '../design_system/design_tokens.dart';
import '../design_system/foundation_widgets.dart';
import '../design_system/messaging_components.dart';
import '../design_system/responsive.dart';
import 'conversation_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

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
                  title: 'Chats',
                  subtitle: 'Conversation workspace foundation',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                const SecureChatFeatureBanner(
                  title: 'Messaging engine not implemented',
                  message:
                      'This Phase 2 screen establishes the final conversation layout without creating fake messages, encryption state, or delivery behavior.',
                ),
                const SizedBox(height: SecureChatSpace.lg),
                SecureChatSurface(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: SecureChatAvatar(label: 'Conversation preview'),
                        title: Text('Conversation UI preview'),
                        subtitle: Text('No real conversation data is loaded.'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.chat_bubble_outline),
                        title: const Text('Open conversation layout'),
                        subtitle: const Text(
                          'Preview only — transport and message persistence are not implemented.',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ConversationScreen(),
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

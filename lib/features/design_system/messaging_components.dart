import 'package:flutter/material.dart';

import 'design_tokens.dart';
import 'foundation_widgets.dart';

class SecureChatAvatar extends StatelessWidget {
  const SecureChatAvatar({required this.label, super.key, this.size = 44});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    image: true,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: SecureChatColors.surfaceRaised,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline,
        size: size * 0.48,
        color: SecureChatColors.muted,
      ),
    ),
  );
}

class SecureChatMessageBubble extends StatelessWidget {
  const SecureChatMessageBubble({
    required this.message,
    required this.timestamp,
    super.key,
    this.isMine = false,
    this.statusLabel,
  });

  final String message;
  final String timestamp;
  final bool isMine;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    final Color background = isMine
        ? SecureChatColors.primary
        : SecureChatColors.surfaceRaised;
    final Color foreground = isMine
        ? SecureChatColors.canvas
        : SecureChatColors.text;

    return Semantics(
      container: true,
      label: 'Message at $timestamp',
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Container(
            margin: const EdgeInsets.only(bottom: SecureChatSpace.sm),
            padding: const EdgeInsets.symmetric(
              horizontal: SecureChatSpace.md,
              vertical: SecureChatSpace.sm,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMine ? 18 : 6),
                bottomRight: Radius.circular(isMine ? 6 : 18),
              ),
              border: isMine
                  ? null
                  : Border.all(color: SecureChatColors.divider),
            ),
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: foreground),
                ),
                const SizedBox(height: SecureChatSpace.xs),
                Wrap(
                  spacing: SecureChatSpace.xs,
                  runSpacing: SecureChatSpace.xxs,
                  children: [
                    Text(
                      timestamp,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: foreground.withValues(alpha: 0.65),
                      ),
                    ),
                    if (statusLabel != null)
                      Text(
                        statusLabel!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: foreground.withValues(alpha: 0.65),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecureChatComposer extends StatefulWidget {
  const SecureChatComposer({
    required this.onSend,
    super.key,
    this.enabled = true,
  });

  final ValueChanged<String>? onSend;
  final bool enabled;

  @override
  State<SecureChatComposer> createState() => _SecureChatComposerState();
}

class _SecureChatComposerState extends State<SecureChatComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final String value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onSend?.call(value);
    _controller.clear();
  }

  Widget _attachmentButton(BuildContext context) => SecureChatIconButton(
    icon: Icons.add_circle_outline,
    label: 'Attachments',
    onPressed: widget.enabled
        ? () => showSecureChatBottomSheet<void>(
            context,
            child: const Text('Attachment actions are not implemented yet.'),
          )
        : null,
  );

  Widget _voiceButton() => SecureChatIconButton(
    icon: Icons.mic_none_outlined,
    label: 'Voice message',
    onPressed: widget.enabled ? () {} : null,
  );

  Widget _sendButton() => SecureChatIconButton(
    icon: Icons.send_rounded,
    label: 'Send',
    onPressed: widget.enabled ? _send : null,
  );

  Widget _field() => Expanded(
    child: TextField(
      controller: _controller,
      enabled: widget.enabled,
      minLines: 1,
      maxLines: 5,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        hintText: 'Write a message',
        isDense: true,
      ),
      onSubmitted: (_) => _send(),
    ),
  );

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.all(SecureChatSpace.sm),
      decoration: const BoxDecoration(
        color: SecureChatColors.surface,
        border: Border(top: BorderSide(color: SecureChatColors.divider)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 420;
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _attachmentButton(context),
                    _field(),
                    _sendButton(),
                  ],
                ),
                Align(alignment: Alignment.centerRight, child: _voiceButton()),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _attachmentButton(context),
              _field(),
              _voiceButton(),
              _sendButton(),
            ],
          );
        },
      ),
    ),
  );
}

class SecureChatFeatureBanner extends StatelessWidget {
  const SecureChatFeatureBanner({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$title. $message',
    child: SecureChatSurface(
      color: SecureChatColors.surfaceRaised,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: SecureChatColors.primary),
          const SizedBox(width: SecureChatSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: SecureChatSpace.xs),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
